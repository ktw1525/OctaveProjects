% RLC Series circuit
clear all
clc

fc = 60;
w = 2*pi*fc;
R = 1;
BW = 20;
Q = fc / BW;
L = Q / w * R
C = 1/L/w/w

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

figure(1);
subplot(3,2,1);
plot(f, XL);
title('Frequency - Reactance(X_L)');
xlabel('Frequentcy [Hz]');
ylabel('XL [Ohm]');
subplot(3,2,2);
plot(f, XC);
title('Frequency - Reactance(X_C)');
xlabel('Frequentcy [Hz]');
ylabel('XC [Ohm]');
subplot(3,2,3);
plot(f, X);
title('Frequency - Reactance(X_T_o_t_a_l)');
xlabel('Frequentcy [Hz]');
ylabel('X [Ohm]');
subplot(3,2,4);
plot(f, I);
title('Frequency - Current [A]');
xlabel('Frequentcy [Hz]');
ylabel('Current [A]');
subplot(3,2,5);
plot(f, Vout);
title('Frequency - Output Voltage [V]');
xlabel('Frequentcy [Hz]');
ylabel('Vout [V]');
subplot(3,2,6);
plot(f, P);
title('Frequency - Power [W]');
xlabel('Frequentcy [Hz]');
ylabel('Power [W]');


dt = 0.0001;
t = 0:dt:2;
fi = 60;
fc = 60;
wi = 2*pi*fi;
V = Vamp*sin(wi*t) + Vamp*sin(wi/10*t) + Vamp/10*sin(wi*10*t);

filter = struct();
filter.dt = dt;
filter.input = V;
filter.fc = fc;
filter.BW = BW;
filter.R = R;
filter = RLC_series(filter);

figure(2);
subplot(2,1,1);
plot(filter.input);
title('Time - Input Voltage [A]');
xlabel('Second [s]');
ylabel('Voltage [V]');
subplot(2,1,2);
plot(filter.output);
title('Time - Output Voltage [A]');
xlabel('Second [s]');
ylabel('Voltage [V]');
