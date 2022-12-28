close all;
clear all;
clc;

# 정전용량이 시간에 따라 변화하고 교류전압을 가했을 때 흐르는 전류

adc_samples = 12000; # 1초당 ADC 샘플개수
t = 0:1/adc_samples:0.050;
f = 60; # 60Hz
w = 2*pi*f;
n = length(t);

Ct = 2.2*10^-9 + 6.6*10^-10 * cos(2*w*t+1);
dCdt = -6.6*10^-10 * 2*w * sin(2*w*t+1);

Vt = 220*sqrt(2)*sin(w*t); # 220V 일 때 전압 ADC 측정 값 * 이득 값
dVdt = 220*sqrt(2)*w*cos(w*t); # 전압 미분기
Zt = dVdt.*Ct + Vt.*dCdt;

figure(1);
subplot(3,1,1);
plot(Vt);
title('V[V]');
subplot(3,1,2);
plot(Ct);
title('C[F]');
subplot(3,1,3);
plot(Zt);
title('Z[A]');

# 흐르는 전류와 전압으로 C 값 계산하기
# Z1 = C1*(V1-V0)/dt + V1*(C1-C0)/dt
# intZ0 + (Z1+Z0)/2*dt = C1*V1;

function C1 = nextCap(Z1, Z0, V1, V0, C0, dt)
    if(abs(V1)<0.1)
        C1 = (Z1*dt + V1*C0)/(2*V1 - V0);  
    else
        C1 = C0*V0/V1 + (Z1+Z0)/2*dt/V1;    
    end
end

Cx = zeros(1, n);
Cx(1) = Ct(1);

for i=2:1:n
    Cx(i) = nextCap(Zt(i), Zt(i-1), Vt(i), Vt(i-1), Cx(i-1), t(i)-t(i-1));  
end



figure(2);
plot(t, Ct, 'bx', t, Cx, 'r-');
ylim([1.5*10^-9, 3*10^-9]);