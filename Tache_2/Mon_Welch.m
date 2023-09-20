function [y] = Mon_Welch(x,Nfft,Fe)
L=floor(length(x)/Nfft);
Y=zeros(L,Nfft);

%Calcul des DSP des segments
for i=0:L-1
    Y(i+1,:)=abs(fft(x(Nfft*i+1:Nfft*(i+1)))).^2;
end
%Calcul de la DSP du signal 
y=fftshift(mean(Y)/(Nfft*Fe));
end