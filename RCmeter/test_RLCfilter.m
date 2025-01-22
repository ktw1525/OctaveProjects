% RLC Series circuit
clear all
clc

fc = 60.155;
wc = 2*pi*fc;
R = 10;
BW = 7.958*4;
Q = fc / BW;
L = Q / wc * R
C = 1/L/wc/wc

f = 1:0.1:500;
w = 2*pi*f;

Vamp = 1;
XL = w*L;
XC = -ones(1,length(w))./w/C;
X = XL + XC;
Z = R + i*X;
I = abs(Vamp*ones(1,length(w))./Z);
Vout = Vamp-I*R;

P = I*Vamp;

dt = 0.0001;
t = 0:dt:2.499;
fi = 60;
wi = 2*pi*fi;
XLi = wi*L;
XCi = -1/wi/C;
Xi = XLi + XCi;
Zi = R + i*Xi;
Ii = abs(Vamp/Zi);
Vouti = Vamp-Ii*R

V = Vamp*sin(wi*t);% + Vamp*sin(wi/10*t) + Vamp/10*sin(wi*10*t);

filter = struct();
filter.dt = dt;
filter.input = V;
filter.fc = fc;
filter.BW = BW;
filter.R = R;
filter = RLC_series(filter);

figure(1);
subplot(2,3,1);
plot(f, XL);
title('Reactance(X_L)');
xlabel('Frequentcy [Hz]');
ylabel('XL [Ohm]');
grid on;
subplot(2,3,2);
plot(f, XC);
title('Reactance(X_C)');
xlabel('Frequentcy [Hz]');
ylabel('XC [Ohm]');
grid on;
subplot(2,3,3);
plot(f, X);
title('Reactance(X_T_o_t_a_l)');
xlabel('Frequentcy [Hz]');
ylabel('X [Ohm]');
grid on;
subplot(2,3,4);
plot(f, I);
title('Current [A]');
xlabel('Frequentcy [Hz]');
ylabel('Current [A]');
grid on;
subplot(2,3,5);
plot(f, Vout, fi, Vouti, 'rx');
title('Output Voltage [V]');
xlabel('Frequentcy [Hz]');
ylabel('Vout [V]');
text(fi, Vouti, sprintf('(%0.2f, %0.2f)', fi, Vouti));
grid on;
subplot(2,3,6);
plot(f, P);
title('Consumption Power [W]');
xlabel('Frequentcy [Hz]');
ylabel('Power [W]');
grid on;

figure(2);
subplot(2,1,1);
plot(filter.input);
title('Time - Input Voltage [A]');
xlabel('Second [s]');
ylabel('Voltage [V]');
grid on;
subplot(2,1,2);
plot(filter.output);
title('Time - Output Voltage [A]');
xlabel('Second [s]');
ylabel('Voltage [V]');
grid on;


Cx = 1.4*10^-4;
Lx = 0.05;
fx = 1/sqrt(Cx*Lx)/2/pi

