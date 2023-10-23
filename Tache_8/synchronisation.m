function [delta_t_chap] = synchronisation(Rl,Sp,Fse,seuilDetection)
%Estimation de delta t prime
    %Calcul de rho delta t prime
num=conv(Rl,flip(Sp));
den1=sqrt(sum(abs(Sp).^2));
den2=sqrt(conv(abs(Rl).^2,ones(1,8*Fse)));

rho=num./(den1*den2);

% Trouver les indices où rho dépasse SeuilDetection
delta_t_chap = find(abs(rho) > seuilDetection);


end



