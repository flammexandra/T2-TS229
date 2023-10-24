function [nom] = nom_avion(bit)
nom = "";
for i=1:6:42
    sous_sequence = flip(bit(i:i+5));
    binary_string = char(flip(sous_sequence(1:4)) + '0');
    int_lettre = bin2dec(binary_string);
    lettre='';


    if ((sous_sequence(5)==0)&&(sous_sequence(6)==0))
        lettre=char(int_lettre+64);
    end
    if ((sous_sequence(5)==1)&&(sous_sequence(6)==0))
        lettre=char(int_lettre+80);
    end
    if (sous_sequence==0)
        lettre=char(32);
    end
    if ((sous_sequence(5)==1)&&(sous_sequence(6)==1))
        lettre=char(int_lettre+'0');
    end
    nom=strcat(nom,lettre);
end
end

