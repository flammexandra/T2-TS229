%% SALLMONE Armela & MONY Alexandra

clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console

%% Tâche 6
P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];

%Longitude de l'ENSEIRB-Matmeca
REF_LON = -0.606629; 
%Latitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884;

% Trame ADS_B
load('adsb_msgs.mat');

lastlongitude=0;
lastlatitude=0;


figure;
affiche_carte(REF_LON, REF_LAT);


for j=1:27
    registre=bit2registre(adsb_msgs(:,j)'); 
    if registre.type > 5
        lastlongitude=registre.longitude;
        lastlatitude=registre.latitude;
        hold on;
        plot(lastlongitude, lastlatitude, 'b.', 'MarkerSize', 15); 
    end
    if registre.type > 0 && registre.type < 5
        text(lastlongitude, lastlatitude, registre.nom, 'Color', 'blue', 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');
    end
end


xlabel('Longitude en degrés');
ylabel('Latitude en degrés');
title('Trajectoire de l''avion');

