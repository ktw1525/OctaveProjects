close all;
clear all;
clc;

sn = 1000;                # 한 주기당 샘플 수
f = 60;                   # 60Hz 상용전원 주파수
w = 2*pi*f;
dt = 1/f/sn;              # 샘플링 주기
Cycles = 0.4;             # 시뮬레이션 하려는 주기 수
t = 0.6*dt:dt:Cycles*dt*sn;    # 시뮬레이션 시간

# 시뮬레이션 조건
Rt = 10^6 - t*10^7 + t.*t*10^11;           
Ct = 10^-9 + t*10^-8 + t.*t*10^-7;

# 솔루션 입력 조건
Vt = 220*sqrt(2)*sin(w*t);          # 입력 1
dVdt = w*220*sqrt(2)*cos(w*t);
dCdt = 10^-8 + 2*10^-11*t;
It = Vt./Rt + Ct.*dVdt + Vt.*dCdt;  # 입력 2

figure('Name', 'R-C Meter','NumberTitle','off');
subplot(2,2,1);
plot(t*10^3, Vt);
grid on;
title('Voltage');
subplot(2,2,2);
plot(t*10^3, It);
grid on;
title('Current');


# C[n+1] = (I[n] - V[n]/R[n] - C[n]*dVdt[n])*dt/V[n] + C[n]
# R[n+1] = V[n+1]*dt/((I[n+1] + I[n])*dt - 2*(C[n+1]*V[n+1] - C[n]*V[n]) - V[n]/R[n]*dt)
Rt_solv = zeros(1,length(Rt));
Ct_solv = zeros(1,length(Ct));
Rt_solv(1) = Rt(1);
Ct_solv(1) = Ct(1);

for i=2:1:length(t)
  R0 = Rt_solv(i-1);
  I0 = It(i-1);
  I1 = It(i);
  V0 = Vt(i-1);
  V1 = Vt(i);
  dVdt0 = dVdt(i-1);
  C0 = Ct_solv(i-1);
  if(abs(V0)<1)
      Ct_solv(i) = (I1 - I0 - dVdt0/R0*dt)/2/dVdt0 + C0;
      C1 = Ct_solv(i);
      # R0 = dVdt0*dt/(I1-I0 - 2*dVdt0*(C1-C0)) 
      Rt_solv(i) = dVdt0*dt/(I1-I0 - 2*dVdt0*(C1-C0));
  else
      Ct_solv(i) = (I0 - V0/R0 - C0*dVdt0)*dt/V0 + C0;
      C1 = Ct_solv(i);
      Rt_solv(i) = V1*dt/((I1+I0)*dt - 2*(C1*V1-C0*V0) - V0/R0*dt);
  end
end

subplot(2,2,3);
plot(t*10^3, Rt, '-b', t*10^3, Rt_solv, 'r');
grid on;
title('R');
legend(['True'; 'Result']);
subplot(2,2,4);
plot(t*10^3, Ct, '-b', t*10^3, Ct_solv, 'r');
grid on;
title('C');
legend(['True'; 'Result']);