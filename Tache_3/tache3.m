%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Initialisation des paramètres

fe = 20e4; % Fréquence d'échantillonnage
Te=1/fe; % Période d'échantillonnage
Ts=1/1e4; % Période d'émission des symboles
Fse=Ts/Te; % Facteur de sur-échantillonnage
M = 2; % Nombre de symboles dans la modulation
n_b = log2(M); % Nombre de bits par symboles
Nb = 88; % Nombre de symboles à émettre par paquet
Nfft = 64; 

% Implémentation de la constelation
const=[0 1];

% Filtre de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
len_p=length(p);

Eg = sum(p.^2);% Energie du filtre de mise en forme

p_a=fliplr(p); % Filtre adapté
sigA2 = 1;% Variance théorique des symboles

eb_n0_dB=0:1:10; %Liste des Eb/No en dB
eb_n0 = 10.^(eb_n0_dB/10); % Liste des Eb/N0
sigma2 = sigA2 * Eg ./ (n_b * eb_n0); % Variance du bruit complexe en bande de base

TEB = zeros(size(eb_n0)); % Tableau des TEB (résultats) 
% Tableau des probabilités d’erreurs théoriques
Pb = qfunc(sqrt(2*eb_n0));


for i = 1:length(eb_n0) 
    disp(i);
    error_cnt = 0;
    bit_cnt = 0;
    while error_cnt < 100
    %% Émetteur
       

    % Filtre de mise en forme
    p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
    len_p=length(p);

        x= randi([0 M-1],1,Nb); % Génération aléatoire des bits
        len_x=length(x);

        %% Encodage 

       
        %Polynôme générateur 
        P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];

        CRC_detector = comm.CRCDetector(P);
        CRC_generator = comm.CRCGenerator(Polynomial=P);

               
        
        % Filtre de mise en forme
        S_l=zeros(1,len_x*len_p);
        
        for j=0:len_x-1
            S_l((len_p*j+1):(len_p*(j+1)))=(1-2*x(j+1))*p;
            
        end
        
        S_l=0.5+S_l;
        
        
        %% Canal
        nl = sqrt(sigma2(i)/2) * (randn(size(S_l)) + 1j*randn(size(S_l))); % Génération du bruit blanc gaussien complexe 
        Y_l=nl+S_l;

        
        %% Récepteur
        % Filtre de reception
        v_l=conv(Y_l,p_a);
        
        
        % Échantillonnage au rythme Ts
        v_m=zeros(1,len_x);
        indices = 0:len_x-1;
        v_m(indices+1) = v_l(indices*Fse+length(p));
 
        % Association Symbole->Bits
        
        x_tilde=(real(v_m)<0);

        % Décodage CRC  
        [pck,erreur] = CRC_detector.step(x_tilde(:));

        
        if erreur
                %disp('Erreur détectée');
                
        else 
                %disp('Pas d erreur');
        end

        
        % Calcul du TEB
        
        error=sum(x(:) ~= x_tilde(:));
        error_cnt = error_cnt+error;  % incrémenter le compteur d'erreurs
        bit_cnt = bit_cnt + Nb*n_b;% incrémenter le compteur de bits envoyés
    end

    TEB(i) = error_cnt/bit_cnt;
end

        



