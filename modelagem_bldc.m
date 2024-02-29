clc; close all; clear all;


%%-----------------  Arquivos do Psim ---------------

data = (csvread('bldcform1.csv',1));
corrente = data(:,7) - 15.98;
Time = data(:,1)- 0.0395;
modulante = data(:,12);
tem = data(:,15);
tem = movmean(tem,1000);
corrente_nu = corrente;
correntemv = movmean(corrente,1800); %% media movel de 1800 
corrente = correntemv;



%%-----------------  Formulas André  ---------------

y_inf = corrente(length(corrente)); %% ultima posição do vetor de corrente
u_inf = modulante(length(modulante)); %% tamanho
ui = 0.6; % primeira posição do vetor 
yi = corrente(1); % primeira posição do vetor de corrente
k = (y_inf - yi)/(u_inf - ui ); %% ganho k 
[MP posMP] = max(corrente);%% maximo sobressinal e posição do MP no vetor
MP = (MP - 12)/12; %% Maximo sobressinal ( 12 é o valor final da corrente em regime perm)
tmax = Time(posMP);
%tp = Time(tmax - 0.0395)
%wd = pi/tp;
%wd = pi/tp;
wd = 2*pi/(0.00136-0.00042);
wd = 2*pi/(0.00042-(-5.8e-5));
wd = 1.3145e+04;
wd = 1.2100e+04;
tp = pi/wd;
ts = 0.0019307; %%  
sigma = 3/(ts);
%--------- calculo do zeta ------
den = pi/(log(MP));
den1 = 1+(den)^2;
zeta = 1/sqrt(den1);
zeta = 0.1;
wn = 3/(ts*zeta);
wn = sqrt((sigma^2)+(wd^2));



T =    0.0004458 - (-5.8e-5);
%%---------------------- FUNÇÃO NO DOMINIO DE LAPLACE ---------------
s = tf('s');
Ts = Time(2) - Time(1);
G = wn^2/((s^2)+2*s*zeta*wn + wn^2);
G = G*15;
[amp,tempo] = step(G);


%%---------------------- Plots -------------------------------

plot(Time,corrente,'b', 'LineWidth', 2, 'DisplayName', 'corrente com media movel')
hold on 
plot(tempo- 7.66e-5,amp,'g', 'LineWidth', 2, 'DisplayName', 'Sistema modelado')
plot(Time,corrente_nu,'m', 'LineWidth', 2, 'DisplayName', 'corrente sem media movel')
plot(Time,modulante,'r', 'LineWidth', 3, 'DisplayName', 'Referência ( Tensão )')
legend('Location', 'NorthWest');
title('Comparação entre as curvas para Modelagem do BLDC')
xlabel('Tempo(s)')
ylabel('Corrente(A)')
grid on 
hold off