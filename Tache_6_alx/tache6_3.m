%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Initialisation des paramètres
Fe = 4e6; % Fréquence d'échantillonnage
adsb_msgs=load('adsb_msgs.mat');
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca


P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1 ]; 

affiche_carte(REF_LON,REF_LAT);
load('/Users/alex/Desktop/Enseirb/T2/TS229/Tache_6_alx/bk_tilde.mat')

vect = Bk_tilde;
registre=bit2registre_me(vect');
if registre.type > 5
    hold on;
    plot(registre.longitude, registre.latitude, 'ob');
end

for i=1:27
    vect = adsb_msgs.adsb_msgs(:,i);
    registre=bit2registre_me(vect');
    disp(registre.type);
    if registre.type > 5
        hold on;
        plot(registre.longitude, registre.latitude, 'ob');
    end
end


%


