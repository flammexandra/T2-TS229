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

lastlongitude=0;
lastlatitude=0;

for i=1:27
    vect = adsb_msgs.adsb_msgs(:,i);
    registre=bit2registre(vect');
    if registre.type > 5
        lastlongitude=registre.longitude;
        lastlatitude=registre.latitude;
        hold on;
        plot(registre.longitude, registre.latitude, 'b.', 'MarkerSize', 15);
    end
    if registre.type > 0 && registre.type < 5
        text(lastlongitude, lastlatitude, registre.nom, 'Color', 'blue', 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    end
end





