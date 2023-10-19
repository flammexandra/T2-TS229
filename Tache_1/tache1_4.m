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
Nfft = 64; 

%Filtres de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
% p0=ones(1,Fse/2);
% p1=ones(1,Fse/2);
len_p=length(p);


p_a=fliplr(p); % Filtre adapté


%% Émetteur
%séquence émise:
Bk=[1,0,0,1,0];
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


% Figure 1: Affichage de sl(t)
figure;
plot(S_l);

% Titre et légendes
title('Signal original S_l(t) ');
xlabel('t');
ylabel('Signal');

% Figure 2: Affichage de rl(t)
figure;
plot(R_l);

% Titre et légendes
title('Signal original R_l(t) ');
xlabel('t');
ylabel('Signal');

% Figure 3: Affichage de rm(t)
figure;
plot(R_m);

% Titre et légendes
title('Signal original R_m(t) ');
xlabel('t');
ylabel('Signal');




