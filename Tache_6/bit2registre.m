function registre =  bit2registre(vecteur)
    
    P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];

    REF_LON = -0.606629; % Longitude de l'ENSEIRB-Matmeca
    REF_LAT = 44.806884; % Latitude de l'ENSEIRB-Matmeca

    %Initialisation d'un registre vide 
    registre = struct('adresse',[],'format',[],'type',[],'nom',[], 'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[]);
    
    % Vérifions que c'est bien une trame ADS : trame ADS si df =17
    format = bin2dec(num2str(vecteur(1:5)));
    

    % Vérifion qu'il y a pas d'erreur : crc
    [error] = decodeCRC(P,vecteur)
    if error == 1
        disp('CRC présente une erreur');
        return 
    end


    % Vérifions que c'est bien une trame ADS
    if format ~= 17
        disp('cest pas une trame ADS');
        return
    end

    registre.format = format;
        
    %L'adresse OASCI de l'appareil:
    adresse = "0x";
    for i=9:4:32
        adresse = strcat(adresse,dec2hex(bin2dec(num2str(vecteur(i:i+3))))); %strcat concatene addr a chaque boucle for
    end
    registre.adresse = adresse ; 

        
        %FTC : format type code 
        registre.type = bin2dec(num2str(vecteur(33:37))); %ftc


        %Position de vol
        if ((registre.type>8 && registre.type<19) || (registre.type>19 && registre.type<23))


            %UTC
            UTC = vecteur(53);
            registre.timeFlag= UTC;

            %CPR 
            CPR = vecteur(54);
            registre.cprFlag = CPR;

            %altitude 
            %registre.altitude = bin2alt(vecteur(56:79));
            r1=vecteur(41:47);
            r2=vecteur(49:52);
            bin_msg =[r1 r2];
    
            %valeur entière non signée r_a
            r_a = bin2dec(num2str(bin_msg));

            % altitude en pieds 
            altitude = 25*r_a - 1000;
            registre.altitude = altitude;

            %Latitude et longitude
            registre.latitude = latitude(vecteur(55:71),CPR) ;
            registre.longitude = longitude(vecteur(72:88),CPR,registre.latitude);
     
        
        %Message d'identification 
        elseif ((registre.type >0) && (registre.type <5)) % cas d'un message d'id
              nom = nom_avion(vecteur(41:88));
              registre.nom = nom;
       


           
        end
end
    

   

   






    
        

  
    
   




            
   
    
    
    













