function [latitude_tram] = latitude(vecteur, CPR)
    
    % calcul de D_lat:
    N_z = 15; %nb de lat géo entre l'équateur et le pôle
    D_lat= 360 / ((4*N_z) - CPR);

    %Calcul de j:
    LAT = bin2dec(num2str(vecteur));
    REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca
    N_b = 17;
    b=(MOD(REF_LAT,D_lat))/D_lat;
    c=LAT/2^N_b;
    d= 0.5 + b - c;
    j = floor(REF_LAT/D_lat)+floor(d);

    % Calcul de la latitude
    latitude_tram = D_lat * (j+LAT/2^N_b);

end