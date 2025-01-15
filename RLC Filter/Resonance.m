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


V = 0.01;
XL = w*L;
XC = -ones(1,length(w))./w/C;
X = XL + XC;
Z = R + i*X;
I = abs(V*ones(1,length(w))./Z);
Vout = V-I*R;
P = I*V;

figure(1);
subplot(3,2,1);
plot(f, XL);
title('Frequency-XL');
xlabel('Frequentcy [Hz]');
ylabel('XL [Ohm]');
subplot(3,2,2);
plot(f, XC);
title('Frequency-XC');
xlabel('Frequentcy [Hz]');
ylabel('XC [Ohm]');
subplot(3,2,3);
plot(f, X);
title('Frequency-X');
xlabel('Frequentcy [Hz]');
ylabel('X [Ohm]');
subplot(3,2,4);
plot(f, I);
title('Frequency-Current [A]');
xlabel('Frequentcy [Hz]');
ylabel('Current [A]');
subplot(3,2,5);
plot(f, Vout);
title('Frequency-Voltage [V]');
xlabel('Frequentcy [Hz]');
ylabel('Voltage [V]');
subplot(3,2,6);
plot(f, P);
title('Frequency-Power [W]');
xlabel('Frequentcy [Hz]');
ylabel('Power [W]');

