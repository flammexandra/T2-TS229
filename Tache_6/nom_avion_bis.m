function [nom] = nom_avion_bis(bit)
nom = "";
for i=1:6:43
    int_lettre=bin2dec(flip(bit(i:i+3)));
    if ((bit(5)==0)&&(bit(6)==0))

        lettre=char(int_lettre+64);
    end
    if ((bit(5)==1)&&(bit(6)==0))
        lettre=char(int_lettre+80);
    end
    if (int_lettre==0)
        lettre=char(32);
    end
    if ((bit(5)==1)&&(bit(6)==1))
        lettre=int_lettre;
    end
    nom=strcat(nom,lettre);
end
end

