%% Mony Alexandra , SALLMONE Armela

clear ; % Efface les variables de l'environnement de travail
close all ; % Ferme les figures ouvertes
clc ; % Efface la console

%% Initialisation des paramètres

N = 2; % 0 ou 1
Nb = 88; 
P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1 ]; 
taille_P = length(P);

x = randi(N-1, 1, Nb);


%% Test

    % test juste
    x_with_CRC_juste = encodeCRC(P, x);
    [erreur_juste] = decodeCRC(P, x_with_CRC_juste);

    
    % test injuste
    x_with_CRC_injuste = encodeCRC(P, x);
    for i = taille_P : Nb
        if x_with_CRC_injuste(i) == 1
                x_with_CRC_injuste(i) = 0;
    else
                x_with_CRC_injuste(i) = 1;
        end
    end
    
    [erreur_injuste] = decodeCRC(P, x_with_CRC_injuste);


%% Affichage des résultats

    % test juste 
    if erreur_juste
        disp('Erreur CRC détectée pour le test juste.');
        
    else
        disp('Pas d erreur pour le test juste');
        
    end
    
    % test injuste
    if erreur_injuste
        disp('Erreur CRC détectée pour le test injuste.');
        
    else
        disp('Pas d erreur pour le test injuste');
        
    end