%% RQ
%décalage en fréquence car l'avion bouge et la différence de matériel entre recepteur et avion
%


%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Initialisation des paramètres
Fe = 20e6; % Fréquence d'échantillonnage
Te=1/Fe; % Période d'échantillonnage
Ts=1/1e6; % Période d'émission des symboles
Fse=Ts/Te; % Facteur de sur-échantillonnage
Ns = 5*256; % Nombre de symboles à émettre par paquet
Nfft = 256; 

%Préambule
Sp=[ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,2*Fse),ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,3*Fse)];

%Filtres de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
% p0=ones(1,Fse/2);
% p1=ones(1,Fse/2);
len_p=length(p);

% Filtre adapté
p_a=fliplr(p); 


%% Émetteur
% %séquence émise:
Bk= randi([0 1],1,Ns); % Génération aléatoire des bits
len_Bk=length(Bk);

% Filtre de mise en forme
Sl=zeros(1,len_Bk*len_p);

for i=0:len_Bk-1
    Sl((len_p*i+1):(len_p*(i+1)))=(1-2*Bk(i+1))*p;

end

%Ajout Préambule
Sl=[Sp, 0.5+Sl];

%Estimation du délai de propagation : δt
delta_t = randi([0, 100])* Te;

% Modélisation d'un Dirac pour décaler Sl
dirac=zeros(1,100);
dirac(floor(delta_t/Te)+1)=1;

% Décalage temporel de Sl
Sl_shifted = conv(Sl,dirac);


% Estimation du décalage en fréquence : δf
delta_f = randi([-1,1]) * 1000; 


% Générer le signal exp(-j2πδf t)
t = (0:length(Sl_shifted)-1) * Te;
exp_signal = exp(-1j * 2 * pi * delta_f * t );%!!


Y_l=Sl_shifted.*exp_signal + 0.001*(randn(size(Sl_shifted)) + 1j*randn(size(Sl_shifted))) ; 

%% Recepteur
Rl=abs(Y_l).^2;

%Estimation de delta t prime
 
delta_t_chap=synchronisation1(Rl,Sp,Fse,Te);

%% Affichage 

if delta_t==delta_t_chap
    disp("δt estimé = δt aléatoire")
end

fprintf("δt estimé : %d \n", delta_t_chap)
fprintf("δt aléatoire : %d\n" ,delta_t)

