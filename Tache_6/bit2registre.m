function registre =  bit2registre(vecteur)
    
    P = [1 1 1 1 1 1 1 1 1 1 1 1 1 0 1 0 0 0 0 0 0 1 0 0 1];

    %Initialisation d'un registre vide 
    registre = struct('adresse',[],'format',[],'type',[],'nom',[], 'altitude',[],'timeFlag',[],'cprFlag',[],'latitude',[],'longitude',[]);

    % Vérifions qu'il y a pas d'erreur : CRC
    [error] = decodeCRC(P,vecteur);
    if error == 1
        disp('CRC: il y a une erreur');
        return 
    end

    % Vérifions que c'est bien une trame ADS : df =17
    format = bin2dec(num2str(vecteur(1:5)));
    if format ~= 17
        disp('cest pas une trame ADS');
        return
    end
    registre.format = format;
        
    %L'adresse OASCI de l'appareil:
    adresse = "0x";
    for i=9:4:32
        adresse = strcat(adresse,dec2hex(bin2dec(num2str(vecteur(i:i+3)))));
    end
    registre.adresse = adresse ; 

        
    %FTC : format type code 
    registre.type = bin2dec(num2str(vecteur(33:37)));


    %Message : Position de vol
    if ((registre.type>8 && registre.type<19) || (registre.type>19 && registre.type<23))

            %UTC
            utc = vecteur(53);
            registre.timeFlag= utc;

            %CPR 
            CPR = vecteur(54);
            registre.cprFlag = CPR;

            %Altitude 
            r1=vecteur(41:47);
            r2=vecteur(49:52);
            bin_msg =[r1 r2];
            r_a = bin2dec(num2str(bin_msg));
            altitude = 25*r_a - 1000;
            registre.altitude = altitude;

            %Latitude et longitude
            registre.latitude = latitude(vecteur(55:71),CPR) ;
            registre.longitude = longitude(vecteur(72:88),CPR,registre.latitude);
     
        
    %Message d'identification 
    elseif ((registre.type >0) && (registre.type <5)) 
            nom = nom_avion(vecteur(41:88));
            registre.nom = nom;
       
    end
end
    

   

   






    
        

  
    
   




            
   
    
    
    













