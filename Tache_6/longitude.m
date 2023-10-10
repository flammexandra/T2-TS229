function [longitude_trame] = longitude(vecteur, CPR, latitude)
    
    N_b = 17;
    LON = bin2dec(num2str(vecteur));
    REF_LON = -0.606629;

    % Calcul de D_lon_i
    if cprNL_(latitude) - CPR > 0
        D_lon = 360 / (cprNL_(latitude)- CPR);
    
    else
         D_lon = 360 ;
    end

    % Calcul de m 
    a= MOD(REF_LON, D_lon);
    b = a / D_lon;
    c = LON / (2^N_b);
    d = 0.5 + b - c;

    m=floor(REF_LON/D_lon)+floor(d);

    %Calcul de la longitude:
    longitude_trame = D_lon * (m+(LON/2^N_b));

end