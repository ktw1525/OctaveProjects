R1 = 10000;
C1 = 10*10^-9;

f = 60;
samples = 200;
t_step = 1/f/samples;
t_end = 1/f*5;
t = 0:t_step:t_end;
w = 2*pi*f;
V1 = 220*sqrt(2)*sin(w*t) + 5*rand(1,length(t));
dV1dt = [0, diff(V1)./diff(t)];


I1 = V1/R1 + C1*dV1dt;
Ig = I1;

figure(1);
subplot(2,1,1);
plot(t, V1);
subplot(2,1,2);
plot(t, Ig);

Rr = R1
Cr = C1

function [Rret, Cret] = calRC(picker, Ig, V1, dV1dt)
	IG = Ig(picker);
	M = [V1(picker); dV1dt(picker);];

	X = IG*inv(M);
	Rret = 1/X(1);
	Cret = X(2);
endfunction

[Rret, Cret] = calRC(100:101, Ig, V1, dV1dt);
Rret
Cret

[Rret, Cret] = calRC(105:106, Ig, V1, dV1dt);
Rret
Cret


