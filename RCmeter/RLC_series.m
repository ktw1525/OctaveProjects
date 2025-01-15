function filter = RLC_series(filter)
  % RLC 직렬필터 Vin 을 RLC 직렬로 연결하고 LC에 출력을 연결
  % fc 주파수를 없애는 필터
  % 입력값이 구조체인지 확인
  if ~isstruct(filter)
    error("입력값이 구조체가 아닙니다.");
  end

  % 필수 필드 확인
  if ~isfield(filter, "R") || ~isfield(filter, "BW") || ~isfield(filter, "fc") || ~isfield(filter, "input") || ~isfield(filter, "dt")
    error("구조체에 필요한 필드 (R, BW, fc, input, dt)가 없습니다.");
  end

  % 필드 초기화
  R = filter.R;
  BW = filter.BW;
  fc = filter.fc;
  input = filter.input;
  dt = filter.dt;
  wc = filter.fc*2*pi;

  % L과 C 계산
  Q = fc / BW;
  filter.L = Q / wc * R;
  filter.C = 1/filter.L/wc/wc;

  L = filter.L;
  C = filter.C;

  % 입력 신호 길이
  len = length(input);

  % 전류 배열 초기화
  filter.I = zeros(1, len);

  % 수치 계산
  for n = 3:len
    filter.I(n) = (L*(2*filter.I(n-1) - filter.I(n-2)) + R*filter.I(n-2)/2*dt - filter.I(n-1)/C*dt*dt + (input(n) - input(n-2))/2*dt)/(L + R/2*dt);
  endfor

  % 출력 계산
  filter.output = input - filter.I * R;

endfunction
