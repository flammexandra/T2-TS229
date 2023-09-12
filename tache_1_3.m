
%% Initialisation des paramètres
fe = 20e4; % Fréquence d2échantillonnage
Te=1/fe; % Période d'échantillonnage
% M = 5; % Nombre de symboles dans la modulation
% n_b = log2(M); % Nombre de bits par symboles
% Ds=1000; % Débit symbole
Ts=1/1e4; % Période d'émission des symboles
Fse=Ts/Te; % Facteur de sur-échantillonnage
% Ns = 5000; % Nombre de symboles à émettre par paquet
% Nfft = 512; 

Eg = sum(g.^2);% Energie du filtre de mise en forme



% Filtre de mise en forme
    % g= 1 sur [0, Ts[
    P=[-1/2*ones(1,Fse/2),1/2*ones(1,Fse/2)];

    g_a=1/Eg*conj(P(end:-1:1)); % Filtre adapté

% Implémentation de la constelation
const=constellation(M);

%signal binaire:
Bk=[1,0,0,1,0];
len_Bk=length(Bk);

% Détermination de sl
sl=[];

for i=1:len_Bk
    if Bk(i) == 0
        sl=[sl,P];
    else
        sl=[sl,-P];
    end
end
sl=0.5+sl;

rl=conv(fliplr(P),sl);


% Échantillonnage au rythme Ts
R_m=zeros(1,len_Bk);
indices = 0:len_Bk-1;
R_m(indices+1) = rl(indices*Fse+length(P));

%plot(sl);
%plot(fliplr(P));
%plot(indices,R_m);


