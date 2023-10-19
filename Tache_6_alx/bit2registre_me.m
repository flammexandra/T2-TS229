function [registre] = bit2registre_me(vect)
registre = struct('adresse',[],'format',[],'type',[],'nom',[],'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[]);

REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca

P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1 ]; 

if decodeCRC(P,vect)
    return;
end

%Format de la voie descendante
format=bin2dec(num2str(vect(1:5)));
if format ~=17
    return;
end


registre.format=format;

% Adresse OACI de l'appareil
adresse=dec2hex(bin2dec(regexprep(num2str(vect(9:32)),'[^\w'']','')));
registre.adresse=adresse;


% Données ADS-B
donnee=vect(33:89);

%Format Type Code
format_type_code=bin2dec(regexprep(num2str(donnee(1:5)),'[^\w'']',''));
registre.type=format_type_code;


%Surface Position

if format_type_code > 0 && format_type_code < 5

    bits=donnee(9:56);
    nom=nom_avion_bis(bits);
    
    registre.nom=nom;
    disp(nom);
end


if format_type_code > 4 && format_type_code < 9
    registre.timeFlag=bin2dec(regexprep(num2str(donnee(21)),'[^\w'']',''));
    registre.cprFlag=bin2dec(regexprep(num2str(donnee(22)),'[^\w'']',''));
    
        %Décodage de la latitude
    LAT=bin2dec(num2str(donnee(23:39)));
     
    D_lat=360/(4*15-registre.cprFlag);
    
    j=floor(REF_LAT/D_lat)+floor(1/2+(REF_LAT-D_lat*floor(REF_LAT/D_lat))/D_lat-LAT/power(2,17));
   
    latitude=D_lat*(j+LAT/power(2,17));
    
    
    registre.latitude=latitude;

        %Décodage de la longitude
    LON=bin2dec(num2str(donnee(40:56)));
   
    N_l=cprNL(latitude);
    %N_l=floor(360*power(acos(1-(1-cos(pi/(2*15)))/power(cos((pi/180)*abs(latitude)),2)),-1));
    if N_l-registre.cprFlag==0
        D_lon=360;
    else 
        D_lon=360/(N_l-registre.cprFlag);
    end

    m=floor(REF_LON/D_lon)+floor(1/2+((REF_LON-D_lon*floor(REF_LON/D_lon))/D_lon-LON/power(2,17)));

    longitude=D_lon*(m+LON/power(2,17));
    registre.longitude=longitude;

end

%Airbone Position
if format_type_code > 8 && format_type_code < 23
        %Décodage de l'altitude
    ra=donnee(9:20);
    ra(8)=[];
    alt=bin2dec(num2str(ra));
    altitude=25*alt-1000;
    registre.altitude=altitude;

    registre.timeFlag=bin2dec(regexprep(num2str(donnee(21)),'[^\w'']',''));
    registre.cprFlag=bin2dec(regexprep(num2str(donnee(22)),'[^\w'']',''));
    
        %Décodage de la latitude
    LAT=bin2dec(num2str(donnee(23:39)));
    
    
    D_lat=360/(4*15-registre.cprFlag);
    
    j=floor(REF_LAT/D_lat)+floor(1/2+(REF_LAT-D_lat*floor(REF_LAT/D_lat))/D_lat-LAT/power(2,17));
   
    latitude=D_lat*(j+LAT/power(2,17));
    
    
    registre.latitude=latitude;

        %Décodage de la longitude
    LON=bin2dec(num2str(donnee(40:56)));
   
    N_l=cprNL(latitude);
    %N_l=floor(360*power(acos(1-(1-cos(pi/(2*15)))/power(cos((pi/180)*abs(latitude)),2)),-1));
    if N_l-registre.cprFlag==0
        D_lon=360;
    else 
        D_lon=360/(N_l-registre.cprFlag);
    end

    m=floor(REF_LON/D_lon)+floor(1/2+((REF_LON-D_lon*floor(REF_LON/D_lon))/D_lon-LON/power(2,17)));

    longitude=D_lon*(m+LON/power(2,17));
    registre.longitude=longitude;

end
