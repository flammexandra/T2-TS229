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

% Filtre de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
% p0=ones(1,Fse/2);
% p1=ones(1,Fse/2);
len_p=length(p);

p_a=fliplr(p); % Filtre adapté
sigA2 = 1;% Variance théorique des symboles

eb_n0_dB=0:1:10; %Liste des Eb/No en dB
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
        S_l=zeros(1,len_Bk*len_p);
        
        for j=0:len_Bk-1
            S_l((len_p*j+1):(len_p*(j+1)))=(1-2*Bk(j+1))*p;
            
        end
        
        S_l=S_l;
        E=mean(abs(S_l).^2);
        sigma2=E*Fse/eb_n0(i);
        %% Canal
        nl = sqrt(sigma2/2) * (randn(size(S_l)) + 1j*randn(size(S_l))); % Génération du bruit blanc gaussien complexe 
        Y_l=nl+S_l;

        %% Récepteur
        % Filtre de reception
        R_l=conv(Y_l,p_a);
        
        
        % Échantillonnage au rythme Ts
        R_m=zeros(1,len_Bk);
        indices = 0:len_Bk-1;
        R_m(indices+1) = R_l(indices*Fse+length(p));
 
        % Association Symbole->Bits
        Bk_tilde=(real(R_m)<0);
        
        % Calcul du TEB
        error=sum(Bk(:) ~= Bk_tilde(:));
        error_cnt = error_cnt+error;  % incrémenter le compteur d'erreurs
        bit_cnt = bit_cnt + Ns;% incrémenter le compteur de bits envoyés
    end
    TEB(i) = error_cnt/bit_cnt;
end


%% Affichage des résultats

figure;
semilogy(eb_n0_dB, Pb, 'r');
hold on;
semilogy(eb_n0_dB, TEB, 'b');

% Titre et légendes
title('Comparaison du TEB simulé et du TEB théorique');
xlabel('Rapport signal sur bruit Eb/N0 (dB)');
ylabel("Taux d erreur binaire (TEB)");
legend('TEB théorique', 'TEB simulé');
grid on;