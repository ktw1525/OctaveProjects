


f = 60;
samples = 200;
t_step = 1/f/samples;
t_end = 1/f*5;
t = 0:t_step:t_end;
w = 2*pi*f;

R = 100000 + 50000 * sin(w/2*t);
C = 10*10^-6 - 9*10^-6 * cos(w/2*t);
dCdt = [0,diff(C)];

V = 220*sqrt(2)*sin(w*t);
dVdt = [0,diff(V)];

I = V./R + C.*dVdt + dCdt.* V;
% I = V * (G + dCdt) + C * dVdt;

figure(1);
subplot(4,1,1);
plot(t, V);
subplot(4,1,2);
plot(t, I);
subplot(4,1,3);
plot(t, R)
subplot(4,1,4);
plot(t, C)

pad = 5;
picker0 = 100-pad:101-pad;
picker1 = 100:101;
picker2 = 100+pad:101+pad;

Rr = R(picker1)
Cr = C(picker1)

Y = I(picker0);
M = [V(picker0); dVdt(picker0)];
X = Y*inv(M);
Rr0 = 1/X(1)
Cr0 = X(2)


Y = I(picker1);
M = [V(picker1); dVdt(picker1)];
X = Y*inv(M);
Rr1 = 1/X(1)
Cr1 = X(2)

Y = I(picker2);
M = [V(picker2); dVdt(picker2)];
X = Y*inv(M);
Rr2 = 1/X(1)
Cr2 = X(2)


dCr1dt = (Cr2 - Cr0)/(picker2(1) - picker0(1));
Rr1 = 1/(1/Rr1 - dCr1dt)



