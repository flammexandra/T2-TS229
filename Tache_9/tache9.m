%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console


%% ADSB Application
%% Initialisation
addpath('Client', 'General', 'MAC', 'PHY');

%% Constants definition
DISPLAY_MASK = '| %12.12s | %10.10s | %6.6s | %3.3s | %6.6s | %3.3s | %8.8s | %11.11s | %4.4s | %12.12s | %12.12s | %3.3s |\n'; % Format pour l'affichage
CHAR_LINE = '+--------------+------------+--------+-----+--------+-----+----------+-------------+------+--------------+--------------+-----+\n'; % Lignes

SERVER_ADDRESS = 'rpprojets.enseirb-matmeca.fr';

% Coordonnees de reference (endroit de l'antenne)
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca

affiche_carte(REF_LON, REF_LAT);

%% Couche Physique
Fe = 4e6; % Frequence d'echantillonnage (imposee par le serveur)
Te=1/Fe; % Période d'échantillonnage
Rb = 1e6;% Debit binaire (=debit symbole)
Fse = floor(Fe/Rb); % Nombre d'echantillons par symboles
seuil_detection = 0.75; % Seuil pour la detection des trames (entre 0 et 1)
Ns=112;

%% Affichage d'une entete en console
fprintf(CHAR_LINE)
fprintf(DISPLAY_MASK,'     n      ',' t (in s) ','Corr.', 'DF', '  AA  ','FTC','   CS   ','ALT (in ft)','CPRF','LON (in deg)','LAT (in deg)','CRC')
fprintf(CHAR_LINE)

%% Paramètres chaine de communication
%Préambule
Sp=[ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,2*Fse),ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,3*Fse)];

%Filtres de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
% p0=ones(1,Fse/2);
% p1=ones(1,Fse/2);
len_p=length(p);

% Filtre adapté
p_a=fliplr(p); 

lastlongitude=0;
lastlatitude=0;

%% Boucle principale
listOfPlanes = [];
n = 1;
while true
    cprintf('blue',CHAR_LINE)
    cplxBuffer = get_buffer(SERVER_ADDRESS);
        
    Y_l=(cplxBuffer)';
    
    %% Recepteur
    Rl=abs(Y_l).^2;
    
    %Estimation de delta t prime
    delta_t_chap=synchronisation(Rl,Sp,Fse,seuil_detection);

    for j=1:length(delta_t_chap)
  
        % Synchronisation
        if delta_t_chap(j)< 2000000-449
            Rl_data=Rl(delta_t_chap(j):delta_t_chap(j)+448);
            
    
            % Filtre de reception
            V_l=conv(Rl_data,p_a);
    
            % Échantillonnage au rythme Ts
            V_m=zeros(1,Ns);
            indices = 0:Ns-1;
            V_m(indices+1) = V_l(indices*Fse+length(p));
    
            % Association Symbole->Bits
    
            Bk_tilde=(real(V_m)<0);    
            registre=bit2registre(Bk_tilde);

            if ~isempty(registre.type) && registre.type > 5
                lastlongitude=registre.longitude;
                lastlatitude=registre.latitude;
                hold on;
                plot(registre.longitude, registre.latitude, 'b.', 'MarkerSize', 15);
            end
            if ~isempty(registre.type) && registre.type > 0 && registre.type < 5
                disp(registre.nom);
                text(lastlongitude, lastlatitude, registre.nom, 'Color', 'blue', 'FontWeight', 'bold', 'HorizontalAlignment', 'left', 'VerticalAlignment', 'bottom');


            end
        end
    end    
end   
