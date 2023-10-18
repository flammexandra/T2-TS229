%% SALLMONE Armela & MONY Alexandra
clear; % Efface les variables de l environnement de travail
close all; % Ferme les figures ouvertes
clc; % Efface la console



%% Initialisation des paramètres
Fse=4; % Facteur de sur-échantillonnage
Fe = 20e6; % Fréquence d'échantillonnage
Te=1/Fe; % Période d'échantillonnage
Ns=112;
buffers=load('buffers.mat');
REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca
seuilDetection=0.7;

%Préambule
Sp=[ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,2*Fse),ones(1,Fse/2),zeros(1,Fse/2),ones(1,Fse/2),zeros(1,3*Fse)];

%Filtres de mise en forme
p=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];
% p0=ones(1,Fse/2);
% p1=ones(1,Fse/2);
len_p=length(p);

% Filtre adapté
p_a=fliplr(p); 

affiche_carte(REF_LON,REF_LAT);


%% Traitement du signal

for i=1:9
    
    Y_l=(buffers.buffers(:,i))';
    
    %% Recepteur
    Rl=abs(Y_l).^2;
    
    %Estimation de delta t prime
    delta_t_chap=synchronisation(Rl,Sp,Fse,seuilDetection);

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
    
            registre=bit2registre_me(Bk_tilde);
            disp(registre.type);
            disp(registre.adresse);
            disp(registre.format);
            disp(registre.nom);
            disp(registre.altitude);
            disp(registre.longitude);
            disp(registre.latitude);
            if registre.type > 5
                hold on;
                plot(registre.longitude, registre.latitude, 'bo');
            end
        end
    end

end
