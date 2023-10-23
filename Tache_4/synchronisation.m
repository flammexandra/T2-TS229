function [delta_t_chap] = synchronisation(Rl,Sp,Fse,Te)
%Estimation de delta t prime
    %Calcul de rho delta t prime
num=conv(Rl,flip(Sp));
den1=sqrt(sum(abs(Sp).^2));
den2=sqrt(conv(abs(Rl).^2,ones(1,8*Fse)));

rho=num./(den1*den2);

% argmax de rho
max_value= max(abs(rho));
argmax=find(rho==max_value);

delta_t_chap=(argmax(1)-160)*Te;
end