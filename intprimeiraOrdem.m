close all, clear all, clc
tau =  0.002563265 ;
kg = 69;
G = tf([69/tau],[kg/tau 1/tau]);
numG = G.Numerator{1};
denG = G.Denominator{1};

n = order(G);

syms s

nG = poly2sym(numG,s);
dG = poly2sym(denG,s);

%% controlador

m = n-1+1;

syms b3 b2 b1 b0 a0 real

vec_nC = [b1 b0];
vec_dC = [a0 0];

nC = poly2sym(vec_nC,s);
dC = poly2sym(vec_dC,s);

phi_cl = collect(nG*nC+dG*dC,s);


zeta = 0.8;
ts = 3*tau;
wn = 4/(zeta*ts);

%polos = [-zeta*wn-j*wn*(sqrt(1-zeta^2)) -zeta*wn+j*wn*(sqrt(1-zeta^2))];
polos = [(-0.707+j*0.707)*wn (-0.707-j*0.707)*wn]; %% polos ITAE
phi_d = collect((s-polos(1))*(s-polos(2)),s)

sol = solve(coeffs(phi_cl,s)==coeffs(phi_d,s))

b0 = double(sol.b0);
b1 = double(sol.b1);
a0 = double(sol.a0);

vec_nC = [b1 b0];
vec_dC = [a0 0];

C = tf(vec_nC,vec_dC)

Gma = C*G;
Gmf = feedback(Gma,1);

[ampmf tmf]= step(Gmf);
[ampgma tma] = step(G);

plot(tma,ampgma,'b', 'LineWidth', 2, 'DisplayName', 'MALHA ABERTA')
hold on 
plot(tmf,ampmf,'g', 'LineWidth', 2, 'DisplayName', 'PI')
legend('Location', 'NorthWest');
title('Comparação entre a malha aberta e a fechada BLDC')
xlabel('Tempo(s)')
ylabel('Corrente(A)')
grid on 
hold off

