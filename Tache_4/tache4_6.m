%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Initialisation des paramètres
Fe = 20e6; % Fréquence d'échantillonnage
Te=1/Fe; % Période d'échantillonnage
Ts=1/1e6; % Période d'émission des symboles
Fse=Ts/Te; % Facteur de sur-échantillonnage
Ns = 1000; % Nombre de symboles à émettre par paquet
Nfft = 256; 

% Implémentation de la constelation
const=[0 1];

%Préambule
Sp=[ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,2*Fse),ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,3*Fse)];

% Filtre de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
% p0=ones(1,Fse/2);
% p1=ones(1,Fse/2);
len_p=length(p);

p_a=fliplr(p); % Filtre adapté
sigA2 = 1;% Variance théorique des symboles

eb_n0_dB=1:15; %Liste des Eb/No en dB
eb_n0 = 10.^(eb_n0_dB/10); % Liste des Eb/N0

TEB = zeros(size(eb_n0)); % Tableau des TEB (résultats) 

% Tableau des probabilités d’erreurs théoriques
Pb = qfunc(sqrt(2*eb_n0)); 


for i = 1:length(eb_n0) 
    disp(i);
    error_cnt = 0;
    bit_cnt = 0;
    while error_cnt < 100
        %% Émetteur          
        Bk= randi([0 1],1,Ns); % Génération aléatoire des bits
        len_Bk=length(Bk);
        
        % Filtre de mise en forme
        Sl=zeros(1,len_Bk*len_p);
        
        for j=0:len_Bk-1
            Sl((len_p*j+1):(len_p*(j+1)))=(1-2*Bk(j+1))*p;
        
        end
        
        %Ajout Préambule
        Sl=[Sp, 0.5+Sl];
        
        %Estimation du délai de propagation : δt
        delta_t = randi([0, 100])* Te;
        
        % Modélisation d'un Dirac pour décaler Sl
        dirac=zeros(1,200);
        dirac(floor(delta_t/Te)+1)=1;
        
        % Décalage temporel de Sl
        Sl_shifted = conv(Sl,dirac);
        
        % Estimation du décalage en fréquence : δf
        delta_f = randi([-1,1]) * 1000; 
        
        
        % Générer le signal exp(-j2πδf t)
        t = (0:length(Sl_shifted)-1) * Te;
        exp_signal = exp(-1j * 2 * pi * delta_f * t *0 );
        
        E=mean(abs(Sl_shifted).^2);
        sigma2=E*Fse/eb_n0(i);

        %% Canal
        nl =  sqrt(sigma2/2) * (randn(size(Sl_shifted)) + 1j*randn(size(Sl_shifted))); % Génération du bruit blanc gaussien complexe 
        Y_l=Sl_shifted.*exp_signal + nl;

        %% Récepteur
        Rl=abs(Y_l).^2;


        % Estimation de delta t prime
            % Calcul de rho delta t prime
        num=conv(Rl,flip(Sp));
        den1=sqrt(sum(abs(Sp).^2));
        den2=sqrt(conv(abs(Rl).^2,ones(1,8*Fse)));
        
        rho=num./(den1*den2);
        
        % argmax de rho
        [max_value,argmax] = max(abs(rho(160:260)));
        %argmax=find(rho==max_value);
        
        delta_t_chap=argmax;

        % Synchronisation
        Rl_data=Rl(delta_t_chap+160:end);

        % Filtre de reception
        V_l=conv(Rl_data,p_a);
          
        % Échantillonnage au rythme Ts
        V_m=zeros(1,len_Bk);
        indices = 0:len_Bk-1;
        V_m(indices+1) = V_l(indices*Fse+length(p));
 
        % Association Symbole->Bits
        
        Bk_tilde=(real(V_m)<0);
        
        % Calcul du TEB
        
        error=sum(Bk(:) ~= Bk_tilde(:));
        error_cnt = error_cnt+error;  % incrémenter le compteur d'erreurs
        bit_cnt = bit_cnt + Ns;% incrémenter le compteur de bits envoyés
    end
    TEB(i) = error_cnt/bit_cnt;
end


%% Affichage des résultats

figure;
semilogy(eb_n0_dB+3, Pb, 'r');
hold on;
semilogy(eb_n0_dB, TEB, 'b');

% Titre et légendes
title('Comparaison du TEB simulé et du TEB théorique');
xlabel('Rapport signal sur bruit Eb/N0 (dB)');
ylabel("Taux d erreur binaire (TEB)");
legend('TEB théorique', 'TEB simulé');
grid on;