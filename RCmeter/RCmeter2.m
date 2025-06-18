% Octave 코드: R, C 병렬 회로에서 R(t), C(t) 측정 시뮬레이션

% 시뮬레이션 설정
ts = 0.00001;  % 샘플링 타임 (1 ms)
t = 0:ts:0.100;  % 1초 동안 시뮬레이션

% 입력 전압 (예제 신호: 1V의 사인파 + 잡음 추가)
V = 220*sqrt(2)*sin(2 * pi * 60 * t) + 0.03*cos(2 * pi * 1000 * t);

% 실제 저항 및 커패시턴스 (시간에 따라 변화하는 모델)
R_actual = 220000;
C_actual = 22*1e-9;

% 전류 계산 (이상적인 모델 기반)
dVdt = ([0 diff(V)/ts] + [diff(V)/ts 0])/2;  % V의 시간 미분 (전방차분법)
I = V ./ R_actual + C_actual .* dVdt;

[VA0,VB0]= separateFreq(1, V, 1/60/ts);
[IA0,IB0]= separateFreq(1, I, 1/60/ts);
#[VA1,VB1]= separateFreq(1.5, V, 1/60/ts);
#[IA1,IB1]= separateFreq(1.5, I, 1/60/ts);

Z0 = (VA0 + j*VB0)/(IA0 + j*IB0);
#Z1 = (VA1 + j*VB1)/(IA1 + j*IB1);

R0 = real(Z0)
X0 = imag(Z0)
#R1 = real(Z1)
#X1 = imag(Z1)

figure(1);
subplot(4,1,1);
plot(V);
subplot(4,1,2);
plot(dVdt);
subplot(4,1,3);
plot(I);
subplot(4,1,4);



