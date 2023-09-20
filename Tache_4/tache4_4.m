%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Initialisation des paramètres
Fe = 20e4; % Fréquence d'échantillonnage
Te=1/Fe; % Période d'échantillonnage
Ts=1/1e4; % Période d'émission des symboles
Fse=Ts/Te; % Facteur de sur-échantillonnage
Ns = 5*256; % Nombre de symboles à émettre par paquet
Nfft = 256; 

%Filtres de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
% p0=ones(1,Fse/2);
% p1=ones(1,Fse/2);
len_p=length(p);


p_a=fliplr(p); % Filtre adapté


%% Émetteur
%séquence émise:
Bk= randi([0 1],1,Ns); % Génération aléatoire des bits
len_Bk=length(Bk);

% Filtre de mise en forme
S_l=zeros(1,len_Bk*len_p);

for i=0:len_Bk-1
    S_l((len_p*i+1):(len_p*(i+1)))=(1-2*Bk(i+1))*p;
    
end

S_l=0.5+S_l;

%% Récepteur
% Filtre de reception
R_l=conv(S_l,p_a);


% Échantillonnage au rythme Ts
R_m=zeros(1,len_Bk);
indices = 0:len_Bk-1;
R_m(indices+1) = R_l(indices*Fse+length(p));

%% Affichage 
figure;
semilogy(freq,DSP_periodogramme, 'r');
hold on;
semilogy(freq,DSP_th, 'b');

% Titre et légendes
title('Comparaison de la DSP théorique et de la DSP par mon periodogramme de Welch');
xlabel('fréquence');
ylabel("Densité spectrale de puissance");
legend('DSP periodogramme', 'DSP théorique');
grid on;

