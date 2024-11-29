f = 60;
samples = 500;
t_step = 1/f/samples;
periods = 1;
totalSamples = samples*periods;
t_end = 1/f*periods;
t = 0:t_step:t_end;
w = 2*pi*f;

V1 = 220*sqrt(2)*sin(w*t) + 220*rand(1, length(t));
V2 = 220*sqrt(2)*sin(w*t+pi*2/3) + 220*rand(1, length(t));
V3 = 220*sqrt(2)*sin(w*t-pi*2/3) + 220*rand(1, length(t));
dV1dt = [diff(V1)/t_step, 0];
dV2dt = [diff(V2)/t_step, 0];
dV3dt = [diff(V3)/t_step, 0];

G1 = 1/100000;
G2 = 2/100000;
G3 = 3/100000;
C1 = 1.1*10^-6;
C2 = 2.2*10^-6;
C3 = 3.3*10^-6;

Ig = V1.*G1 + C1.*dV1dt + V2.*G2 + C2.*dV2dt + V3.*G3 + C3.*dV3dt;


figure(1);
subplot(6,1,1);
plot(t, V1, 'r', t, V2, 'b', t, V3, 'g');
subplot(6,1,2);
plot(t, Ig, 'r');

% V11은 전압신호 V1에 필터1을적용
% V12은 전압신호 V1에 필터2을적용
% I01은 전류신호 I0에 필터1을적용
% I02은 전류신호 I0에 필터2을적용

FilterR1 = 10;
FilterC1 = 220*10^-6;
FilterR2 = 20;
FilterC2 = 0.4*10^-5;
FilterR3 = 40;
FilterC3 = 0.8*10^-5;
FilterR4 = 60;
FilterC4 = 1.2*10^-5;
FilterR5 = 80;
FilterC5 = 1.8*10^-5;
FilterR6 = 100;
FilterC6 = 2.2*10^-12;

V11 = applyRCFilter(V1, t_step, FilterR1, FilterC1);
V12 = applyRCFilter(V1, t_step, FilterR2, FilterC2);
V13 = applyRCFilter(V1, t_step, FilterR3, FilterC3);
V14 = applyRCFilter(V1, t_step, FilterR4, FilterC4);
V15 = applyRCFilter(V1, t_step, FilterR5, FilterC5);
V16 = applyRCFilter(V1, t_step, FilterR6, FilterC6);

V21 = applyRCFilter(V2, t_step, FilterR1, FilterC1);
V22 = applyRCFilter(V2, t_step, FilterR2, FilterC2);
V23 = applyRCFilter(V2, t_step, FilterR3, FilterC3);
V24 = applyRCFilter(V2, t_step, FilterR4, FilterC4);
V25 = applyRCFilter(V2, t_step, FilterR5, FilterC5);
V26 = applyRCFilter(V2, t_step, FilterR6, FilterC6);

V31 = applyRCFilter(V3, t_step, FilterR1, FilterC1);
V32 = applyRCFilter(V3, t_step, FilterR2, FilterC2);
V33 = applyRCFilter(V3, t_step, FilterR3, FilterC3);
V34 = applyRCFilter(V3, t_step, FilterR4, FilterC4);
V35 = applyRCFilter(V3, t_step, FilterR5, FilterC5);
V36 = applyRCFilter(V3, t_step, FilterR6, FilterC6);

Ig1 = applyRCFilter(Ig, t_step, FilterR1, FilterC1);
Ig2 = applyRCFilter(Ig, t_step, FilterR2, FilterC2);
Ig3 = applyRCFilter(Ig, t_step, FilterR3, FilterC3);
Ig4 = applyRCFilter(Ig, t_step, FilterR4, FilterC4);
Ig5 = applyRCFilter(Ig, t_step, FilterR5, FilterC5);
Ig6 = applyRCFilter(Ig, t_step, FilterR6, FilterC6);

dVdt11 = [diff(V11)/t_step,0];
dVdt12 = [diff(V12)/t_step,0];
dVdt13 = [diff(V13)/t_step,0];
dVdt14 = [diff(V14)/t_step,0];
dVdt15 = [diff(V15)/t_step,0];
dVdt16 = [diff(V16)/t_step,0];

dVdt21 = [diff(V21)/t_step,0];
dVdt22 = [diff(V22)/t_step,0];
dVdt23 = [diff(V23)/t_step,0];
dVdt24 = [diff(V24)/t_step,0];
dVdt25 = [diff(V25)/t_step,0];
dVdt26 = [diff(V26)/t_step,0];

dVdt31 = [diff(V31)/t_step,0];
dVdt32 = [diff(V32)/t_step,0];
dVdt33 = [diff(V33)/t_step,0];
dVdt34 = [diff(V34)/t_step,0];
dVdt35 = [diff(V35)/t_step,0];
dVdt36 = [diff(V36)/t_step,0];

subplot(6,1,3);
plot(t, [V11;V12;V13;V14;V15;V16]);
subplot(6,1,4);
plot(t, [V21;V22;V23;V24;V25;V26]);
subplot(6,1,5);
plot(t, [V31;V32;V33;V34;V35;V36]);
subplot(6,1,6);
plot(t, [Ig1;Ig2;Ig3;Ig4;Ig5;Ig6]);

Gr1 = [];
Cr1 = [];
Gr2 = [];
Cr2 = [];
Gr3 = [];
Cr3 = [];

idx = 2:1:totalSamples;
for i=idx
  Y = [Ig1(i); Ig2(i); Ig3(i); Ig4(i); Ig5(i); Ig6(i);];
  M = [ 
    V11(i), dVdt11(i), V21(i), dVdt21(i), V31(i), dVdt31(i);
    V12(i), dVdt12(i), V22(i), dVdt22(i), V32(i), dVdt32(i);
    V13(i), dVdt13(i), V23(i), dVdt23(i), V33(i), dVdt33(i);
    V14(i), dVdt14(i), V24(i), dVdt24(i), V34(i), dVdt34(i);
    V15(i), dVdt15(i), V25(i), dVdt25(i), V35(i), dVdt35(i);
    V16(i), dVdt16(i), V26(i), dVdt26(i), V36(i), dVdt36(i);
  ];
  X = inv(M)*Y
  Gr1 = [Gr1, X(1)];
  Cr1 = [Cr1, X(2)];
  Gr2 = [Gr2, X(3)];
  Cr2 = [Cr2, X(4)];
  Gr3 = [Gr3, X(5)];
  Cr3 = [Cr3, X(6)];
endfor

figure(2);
subplot(3,2,1);
plot(t, G1, 'r', t(idx), Gr1, 'b');
subplot(3,2,2);
plot(t, C1, 'r', t(idx), Cr1, 'b');
subplot(3,2,3);
plot(t, G2, 'r', t(idx), Gr2, 'b');
subplot(3,2,4);
plot(t, C2, 'r', t(idx), Cr2, 'b');
subplot(3,2,5);
plot(t, G3, 'r', t(idx), Gr3, 'b');
subplot(3,2,6);
plot(t, C3, 'r', t(idx), Cr3, 'b');

mean(Gr1)
mean(Gr2)
mean(Gr3)
mean(Cr1)
mean(Cr2)
mean(Cr3)

