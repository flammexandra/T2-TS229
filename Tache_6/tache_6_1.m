%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Tâche 6

P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];
Fe=4e6;
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca

% trame ADS_B
load('adsb_msgs.mat');

M = size(adsb_msgs,2); % 27 car le la matrice a 27 colonnes 

for i=1:M
    la_trame(i) = bit2registre(adsb_msgs(:,i)'); 
end

i=1;
for j=1:27
    if (la_trame(j).type == 12)
        lon_point(i) = la_trame(j).longitude;
        lat_point(i) = la_trame(j).latitude;
        i = i+1;
        
    end
end

figure;
affiche_carte(REF_LON,REF_LAT);
hold on;
plot(lon_point,lat_point, 'b.-');
xlabel('Longitude en degrés');
ylabel('Latitude en degrés');
title('Trajectoire de l''avion');
















