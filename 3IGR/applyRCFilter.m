function filtered_signal = applyRCFilter(signal, dt, R, C)
  % applyRCFilter: RC 필터를 적용하여 신호를 필터링
  % signal: 원신호 시계열 데이터 (벡터)
  % dt: 시간 간격 (샘플링 간격)
  % R: 저항 값 (옴)
  % C: 커패시터 값 (패럿)
  %
  % Returns:
  % filtered_signal: RC 필터가 적용된 신호
  
  % RC 필터의 시간 상수 계산
  tau = R * C;
  
  % 필터 계수
  alpha = dt / (tau + dt);
  
  % 필터링 결과 저장할 벡터 초기화
  filtered_signal = zeros(size(signal));
  
  % 첫 번째 값 초기화 (원신호와 동일)
  filtered_signal(1) = signal(1);
  
  % 필터 적용 (재귀 방식)
  for i = 2:length(signal)
    filtered_signal(i) = alpha * signal(i) + (1 - alpha) * filtered_signal(i-1);
  end
end
