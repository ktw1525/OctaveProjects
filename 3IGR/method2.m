R1 = 10000;
C1 = 10*10^-9;
R2 = 12300;
C2 = 12*10^-9;
R3 = 19000;
C3 = 22*10^-9;

f = 60;
samples = 200;
t_step = 1/f/samples;
t_end = 1/f*5;
t = 0:t_step:t_end;
w = 2*pi*f;
V1 = 220*sqrt(2)*sin(w*t) + 5*rand(1,length(t));
V2 = 220*sqrt(2)*sin(w*t + 2/3*pi) + 5*rand(1,length(t));
V3 = 220*sqrt(2)*sin(w*t - 2/3*pi) + 5*rand(1,length(t));
dV1dt = [0, diff(V1)];
dV2dt = [0, diff(V2)];
dV3dt = [0, diff(V3)];

I1 = V1/R1 + C1*dV1dt;
I2 = V2/R2 + C2*dV2dt;
I3 = V3/R3 + C3*dV3dt;

Ig = I1 + I2 + I3;

figure(1);
subplot(2,1,1);
plot(t, [V1;V2;V3]);
subplot(2,1,2);
plot(t, Ig);

Rr = [R1, R2, R3]
Cr = [C1, C2, C3]

function [Rret, Cret] = calRC(picker, Ig, V1, dV1dt, V2, dV2dt, V3, dV3dt)
	IG = Ig(picker);
	M = [V1(picker); dV1dt(picker); V2(picker); dV2dt(picker); V3(picker); dV3dt(picker);];

	X = IG*inv(M);
	Rret = [1/X(1), 1/X(3), 1/X(5)];
	Cret = [X(2), X(4), X(6)];
endfunction

[Rret, Cret] = calRC(100:105, Ig, V1, dV1dt, V2, dV2dt, V3, dV3dt);
Rret
Cret

[Rret, Cret] = calRC(105:110, Ig, V1, dV1dt, V2, dV2dt, V3, dV3dt);
Rret
Cret


