function [nom_d_avion] = nom(vecteur)
nom_d_avion = "";   
for i=1:6:43
    nombre = bin2dec(num2str(flip(vecteur(i:i+5))));
    if nombre==32
        caractere="A";
    elseif nombre==16
            caractere="B";
    elseif nombre==48
            caractere="C";
    elseif nombre==8
            caractere="D";
    elseif nombre==40
            caractere="E";
    elseif nombre==24
            caractere="F";
    elseif nombre==56
            caractere="G";
    elseif nombre==4
            caractere="H";
    elseif nombre==36
            caractere="I";
    elseif nombre==20
            caractere="J";
    elseif nombre==52
            caractere="K";
    elseif nombre==12
            caractere="L";
    elseif nombre==44
            caractere="M";
    elseif nombre==28
            caractere="N";
    elseif nombre==60
            caractere="O";
    elseif nombre==2
            caractere="P";
    elseif nombre==34
            caractere="Q";
    elseif nombre==18
            caractere="R";
    elseif nombre==50
            caractere="S";
    elseif nombre==10
            caractere="T";
    elseif nombre==42
            caractere="U";
    elseif nombre==26
            caractere="V";
    elseif nombre==58
            caractere="W";
    elseif nombre==6
            caractere="X";
    elseif nombre==38
            caractere="Y";
    elseif nombre==22
            caractere="Z";
    elseif nombre==1
            caractere=" ";
    elseif nombre==3
            caractere="0";
    elseif nombre==35
            caractere="1";
    elseif nombre==19
            caractere="2";
    elseif nombre==51
            caractere="3";
    elseif nombre==11
            caractere="4";
    elseif nombre==43
            caractere="5";
    elseif nombre==27
            caractere="6";
    elseif nombre==59
            caractere="7";
    elseif nombre==7
            caractere="8";
    elseif nombre==39
            caractere="9";
    else
        caractere = "?";
    end
    nom_d_avion=strcat(nom_d_avion,caractere);
end
end

