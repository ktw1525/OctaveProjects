clear all
close all
clc

f = 60;
w = 2*pi*f;
Ns = 200; % 한주기당 샘플 수
Ss = f * Ns; % ADC 속도
Ts = 1/Ss; % 샘플링 시간
Tp = 0.05; % 샘플 길이

t = 0:Ts:Tp;
Vi = 220; % 입력전압 rms
V = Vi*sqrt(2)*sin(w*t); % 전압 ADC 샘플
dVdt = Vi*sqrt(2)*w*cos(w*t); 

figure(1);
subplot(2,1,1);
plot(t, V);
subplot(2,1,2);
R = 20000*t + 2000;
C = 10^-9*(-22000*t + 2200);
I = V./R + C .* dVdt;
plot(t, I);


figure(2);
subplot(2,2,1);
plot(t,R);
subplot(2,2,3);
plot(t,C);

Ro = ones(length(R)-1,1);
Co = ones(length(C)-1,1);
for i=1:1:length(Ro)
  M = [V(i), dVdt(i); V(i+1), dVdt(i+1)];
  B = [I(i); I(i+1)];  
  X = inv(M) * B;
  Ro(i) = 1 / X(1);
  Co(i) = X(2);
end

subplot(2,2,2);
plot(Ro);
subplot(2,2,4);
plot(Co);