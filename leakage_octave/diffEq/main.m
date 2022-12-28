close all;
clear all;
clc;

# 정전용량이 시간에 따라 변화하고 교류전압을 가했을 때 흐르는 전류

adc_samples = 12000; # 1초당 ADC 샘플개수
t = 0:1/adc_samples:0.050;
f = 60; # 60Hz
w = 2*pi*f;
n = length(t);

Rt = 2*10^6 + 5*10^5*cos(w*t+1);
Ct = 2.2*10^-9 + 6.6*10^-10 * cos(w*t+1);
dCdt = -6.6*10^-10 * w * sin(w*t+1);

Vt = 220*sqrt(2)*cos(w*t); # 220V 일 때 전압 ADC 측정 값 * 이득 값
dVdt = -220*sqrt(2)*w*sin(w*t); # 전압 미분기
Zt = Vt./Rt + dVdt.*Ct + Vt.*dCdt;

figure(1);
subplot(4,1,1);
plot(Vt);
title('V[V]');
subplot(4,1,2);
plot(Zt);
title('Z[A]');
subplot(4,1,3);
plot(Rt);
title('R[ohm]');
subplot(4,1,4);
plot(Ct);
title('C[F]');

#Z1 = V1/R1 + C1*dVdt1 + V1*dCdt1
#dCdt = Z/V - 1/R - C*dVdt/V
#C1 = C0 + (Z0/V0 - 1/R0 - C0*dVdt0/V0)*dt
# V1/R1 = Z1 - C1*dVdt1 - V1*dCdt1
# R1 = V1/(Z1 - C1*dVdt1 - V1*dCdt1);

#C1 = C0 + Z0/V0*dt - dt/R0 - C0*(V1/V0-1);
#R1 = V1*dt/(C0*V0 - V1*C1 + Z1*dt)

# 흐르는 전류와 전압으로 C 값 계산하기
# Z1 = V1/R1 + C1*(V1-V0)/dt + V1*(C1-C0)/dt
#   Z1*dt + C0*V1 = V1*dt/R1 + (2*V1-V0)*C1
# intZ + (Z1+Z0)/2*dt = intRV + (V1/R1 + V0/R0)/2*dt + C1*V1
#   intZ0 - intRV0 + (Z1+Z0)/2*dt = (V1/R1 + V0/R0)/2*dt + C1*V1
#   intZ0 - intRV0 = C0*V0
#   C0*V0 + (Z1+Z0)/2*dt - V0/R0/2*dt = V1/2*dt/R1 + V1*C1
# intZ + Z1*dt = intRV + V1/R1*dt + C1*V1
#   intZ0 - intRV0 + Z1*dt = V1/R1*dt + C1*V1
#   intZ0 - intRV0 = C0*V0
#   C0*V0 + Z1*dt = V1*dt/R1 + V1*C1

# Z1*dt + V1*C0 = V1*dt*G1 + (2*V1-V0)*C1;
# (Z1+Z0)/2*dt + V0*C0 - V0*G0/2*dt = V1/2*dt*G1 + V1*C1;
# V0 = 0

# V1*dt*V1 = (2*V1-V0)*V1*dt
# V1 = V0

function [R1, C1] = solv(Z0, Z1, V0, V1, R0, C0, dt, dCdt0, dCdt1, dVdt1)
  C1 = C0 + dCdt0*dt;
#  R1 = V1*dt/(C0*V0 - V1*C1 + Z1*dt);
  R1 = V1/(Z1 - C1*dVdt1 - V1*dCdt1);

end

Rx = zeros(1, n);
Rx(1) = Rt(1);
Cx = zeros(1, n);
Cx(1) = Ct(1);


for i=2:1:n
    [Rx(i), Cx(i)] = solv(Zt(i-1), Zt(i), Vt(i-1), Vt(i), Rx(i-1), Cx(i-1), t(i)-t(i-1), dCdt(i-1), dCdt(i), dVdt(i));
end


figure(2);
subplot(2,1,1);
plot(t, Rt, 'bx', t, Rx, 'r-');
ylim([1*10^6, 3*10^6]);
subplot(2,1,2);
plot(t, Ct, 'bx', t, Cx, 'r-');
ylim([1.5*10^-9, 3*10^-9]);