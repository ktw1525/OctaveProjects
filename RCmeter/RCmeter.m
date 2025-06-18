% Octave 코드: R, C 병렬 회로에서 R(t), C(t) 측정 시뮬레이션

% 시뮬레이션 설정
ts = 0.00001;  % 샘플링 타임 (1 ms)
t = 0:ts:0.500;  % 1초 동안 시뮬레이션

% 입력 전압 (예제 신호: 1V의 사인파 + 잡음 추가)
V = sin(2 * pi * 60 * t) + 0.03*cos(2 * pi * 1000 * t);

% 실제 저항 및 커패시턴스 (시간에 따라 변화하는 모델)
R_actual = 1000 + 500 * sin(2 * pi * 1 * t);  % 1kΩ ± 500Ω 변화
C_actual = 1e-6 * (1 + 0.5 * cos(2 * pi * 2 * t));  % 1uF ± 0.5uF 변화

% 전류 계산 (이상적인 모델 기반)
dVdt = [0 diff(V)/ts];  % V의 시간 미분 (전방차분법)
I = V ./ R_actual + C_actual .* dVdt;

% R 추정 (dV/dt가 작은 구간에서 근사)
V_threshold = (max(V) - min(V))*0.003;  % 작은 dV/dt 기준
dVdt_threshold = (max(dVdt) - min(dVdt))*0.003;  % 작은 dV/dt 기준
R_est = nan(size(t));
C_est = nan(size(t));

for k = 1:length(t)
    if abs(dVdt(k)) < dVdt_threshold
        R_est(k) = V(k) / I(k);  % 단순 근사
    elseif abs(V(k)) < V_threshold
        C_est(k) = I(k) / dVdt(k);
    end
end

% 보간 처리 (NaN 값 제거)
valid_idx = ~isnan(R_est);
R_est = interp1(t(valid_idx), R_est(valid_idx), t, 'linear', 'extrap');
valid_idx = ~isnan(C_est);
C_est = interp1(t(valid_idx), C_est(valid_idx), t, 'linear', 'extrap');

% I 재계산 및 오차율 평가
I_est = V ./ R_est + C_est .* dVdt;
error_ratio = abs((I - I_est) ./ I);

% 오차율이 0.03 미만인 값만 보간된 값 유지
valid_idx = find(error_ratio > 0.03);
R_est(valid_idx) = nan;
C_est(valid_idx) = nan;

window_size = 10;
R_est = movmean(R_est, window_size);
C_est = movmean(C_est, window_size);

% 결과 플롯
figure(1);
subplot(5,1,1);
plot(t, V);
xlabel('Time (s)'); ylabel('Voltage (V)'); grid on;
title('Input Voltage');

subplot(5,1,2);
plot(t, R_actual, 'b', t, R_est, 'r--');
legend('Actual R', 'Estimated R');
xlabel('Time (s)'); ylabel('Resistance (Ω)'); grid on;
title('Resistance Estimation');

subplot(5,1,3);
plot(t, (R_est-R_actual)./R_actual*100, 'b');
xlabel('Time (s)'); ylabel('Error rate (%%)'); grid on;
title('Resistance Error rate');
ylim([-3,3]);

subplot(5,1,4);
plot(t, C_actual, 'b', t, C_est, 'r--');
legend('Actual C', 'Estimated C');
xlabel('Time (s)'); ylabel('Capacitance (F)'); grid on;
title('Capacitance Estimation');

subplot(5,1,5);
plot(t, (C_est-C_actual)./C_actual*100, 'b');
xlabel('Time (s)'); ylabel('Error rate (%%)'); grid on;
title('Capacitance Error rate');
ylim([-3,3]);
