close all;
clear all;
clc;

adc_samples = 200; # 1주기당 ADC 샘플개수
n = 1:1:200;
f = 60; # 60Hz

# 검증용 실험 조건 1
R_ins = 10^6; # 절연저항 1 Mohm
C_ins = 0; # 정전용량 0 F

# 검증용 실험 데이터 생성
adc_V = 220*sqrt(2)*sin(2*pi/adc_samples * n); # 220V 일 때 전압 ADC 측정 값 * 이득 값
dVdt = 220*sqrt(2)*2*pi*f/adc_samples*cos(2*pi/adc_samples * n); # 전압 미분기
adc_Z = adc_V/R_ins + dVdt * C_ins;
figure(1);
subplot(3,1,1);
plot(adc_V);
subplot(3,1,2);
plot(dVdt);
subplot(3,1,3);
plot(adc_Z);

# 기본파 산출방법
[Vx, Vy] = separateFreq(1, adc_V, adc_samples); # 전압 벡터
[Zx, Zy] = separateFreq(1, adc_Z, adc_samples); # 누설전류 벡터
# Vx가 220이 나왔는지 확인
# Zx가 0.00022가 나왔는지 확인

# 검증용 실험 조건 2
R_ins = 500*10^3; # 절연저항 500 kohm
C_ins = 10*10^-9; # 정전용량 10 nF

# 검증용 실험 데이터 생성
adc_V = 220*sqrt(2)*sin(2*pi/adc_samples * (n + 180)); # 220V 일 때 전압 ADC 측정 값 * 이득 값
dVdt = 220*sqrt(2)*2*pi*f/adc_samples*cos(2*pi/adc_samples * (n + 180)); # 전압 미분 값
adc_Z = adc_V/R_ins + dVdt * C_ins;
figure(2);
subplot(3,1,1);
plot(adc_V);
subplot(3,1,2);
plot(dVdt);
subplot(3,1,3);
plot(adc_Z);

# n 고조파 산출방법
Vx_hd0 = 1:11;
Vy_hd0 = 1:11;
Zx_hd0 = 1:11;
Zy_hd0 = 1:11;
for i=1:1:11
  [Vx_hd0(i), Vy_hd0(i)] = separateFreq(i, adc_V, adc_samples); # 계산한 전압 벡터
  [Zx_hd0(i), Zy_hd0(i)] = separateFreq(i, adc_Z, adc_samples); # 계산한 전압 벡터
end

# 전압 벡터(기본파)가 기준이 되도록(X 좌표 축으로 이동되도록) 좌표 변환하기
Vx_hd1 = 1:11;
Vy_hd1 = 1:11;
Zx_hd1 = 1:11;
Zy_hd1 = 1:11;
Xref = Vx_hd0(1);
Yref = Vy_hd0(1);
for i=1:1:11
  [Vx_hd1(i), Vy_hd1(i)] = transformationVector(Vx_hd0(i),Vy_hd0(i),Xref,Yref); # 계산한 전압 벡터
  [Zx_hd1(i), Zy_hd1(i)] = transformationVector(Zx_hd0(i),Zy_hd0(i),Xref,Yref); # 계산한 전압 벡터
end

