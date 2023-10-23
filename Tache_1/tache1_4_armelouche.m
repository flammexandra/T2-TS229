%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Initialisation des paramètres
fe = 20e4; % Fréquence d'échantillonnage
Te=1/fe; % Période d'échantillonnage
Ts=1/1e4; % Période d'émission des symboles
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


% Affichage dans une seule figure
figure;

% Affichage de sl(t)
subplot(3,1,1);
plot(S_l);
title('Signal original S_l(t)');
xlabel('t');
ylabel('Signal');

% Affichage de rl(t)
subplot(3,1,2);
plot(R_l);
title('Signal original R_l(t)');
xlabel('t');
ylabel('Signal');

% Affichage de rm(t)
subplot(3,1,3);
plot(R_m);
title('Signal original R_m(t)');
xlabel('t');
ylabel('Signal');
