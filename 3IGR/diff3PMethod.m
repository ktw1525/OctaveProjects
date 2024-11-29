f = 60;
samples = 100;
t_step = 1/f/samples;
periods = 5;
totalSamples = samples*periods;
t_end = 1/f*periods;
t = 0:t_step:t_end;
w = 2*pi*f;

V1 = 220*sqrt(2)*sin(w*t);
V2 = 220*sqrt(2)*sin(w*t+pi*2/3);
V3 = 220*sqrt(2)*sin(w*t-pi*2/3);
G1 = 1/1000 + 1/5000 * sin(w/6*t);
G2 = 1/1000 + 1/5000 * sin(w/6*t);
G3 = 1/1000 + 1/5000 * sin(w/6*t);
C1 = 10*10^-6 - 9*10^-6 * cos(w/2*t);
C2 = 10*10^-6 - 9*10^-6 * cos(w/2*t);
C3 = 10*10^-6 - 9*10^-6 * cos(w/2*t);
I1 = V1.*G1 + C1.*dVdt1


% V11은 전압신호 V1에 필터1을적용
% V12은 전압신호 V1에 필터2을적용
% I01은 전류신호 I0에 필터1을적용
% I02은 전류신호 I0에 필터2을적용


V1 = applyRCFilter(V, t_step, 10000, 10*10^-6);
V2 = applyRCFilter(V, t_step, 50000, 3*10^-6);
dVdt1 = [0, diff(V1)/t_step];
dVdt2 = [0, diff(V2)/t_step];
I1 = V1.*G + C.*dVdt1
I2 = V2.*G + C.*dVdt2

figure(1);
subplot(4,1,1);
plot(t, V1, 'r', t, V2, 'b');
subplot(4,1,2);
plot(t, I1, 'r', t, I2, 'b');

Gr = [1/1000,1/1000];
Cr = [10*10^-6,10*10^-6];
for i=2:1:totalSamples
  Y = [I1(i); I2(i);];
  M = [ V1(i), dVdt1(i); V2(i), dVdt2(i); ];
  X = inv(M)*Y
  Gr = [Gr, X(1)];
  Cr = [Cr, X(2)];
endfor

subplot(4,1,3);
plot(t, G, 'g', t, Gr, 'b:');
subplot(4,1,4);
plot(t, C, 'g', t, Cr, 'b:');

C = 10*10^-6 - 9*10^-6 * cos(w/2*t);
dCdt = [0, diff(C)/t_step];


% V1은 전압신호 V에 필터1을적용
% V2은 전압신호 V에 필터2을적용
% I1은 전류신호 I에 필터1을적용
% I2은 전류신호 I에 필터2을적용
V1 = applyRCFilter(V, t_step, 10000, 10*10^-6);
V2 = applyRCFilter(V, t_step, 50000, 3*10^-6);
dVdt1 = [0, diff(V1)/t_step];
dVdt2 = [0, diff(V2)/t_step];
I1 = V1.*G + C.*dVdt1
I2 = V2.*G + C.*dVdt2

figure(1);
subplot(4,1,1);
plot(t, V1, 'r', t, V2, 'b');
subplot(4,1,2);
plot(t, I1, 'r', t, I2, 'b');

Gr = [1/1000,1/1000];
Cr = [10*10^-6,10*10^-6];
for i=2:1:totalSamples
  Y = [I1(i); I2(i);];
  M = [ V1(i), dVdt1(i); V2(i), dVdt2(i); ];
  X = inv(M)*Y
  Gr = [Gr, X(1)];
  Cr = [Cr, X(2)];
endfor

subplot(4,1,3);
plot(t, G, 'g', t, Gr, 'b:');
subplot(4,1,4);
plot(t, C, 'g', t, Cr, 'b:');
