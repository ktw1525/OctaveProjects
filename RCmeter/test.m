% 샘플 데이터 생성

N = 100;
x = rand(N,1);
y = rand(N,1);
z = 355*x.^2 + 100*x + 52*y + 400 + rand(N,1) ;  % 실제 데이터와 유사하게 노이즈 추가

% 초기 파라미터 설정
params = [1, 1, 1, 1];  % a, b, c, d, e
params0 = [1, 1, 1, 1];  % a, b, c, d, e

% 학습률 설정
alpha = 0.5;

% 반복 횟수
iterations = 10000;

% 경사 하강법 실행
for iter = 1:iterations
    % 예측값 계산
    predictions = params(1)*x.^2 + params(2)*x + params(3)*y + params(4);
    
    % 오차 계산
    errors = predictions - z;
    Err = sum(errors.*errors)/N;
    
    % 그라디언트 계산
    grad_a = sum(2 * errors .* x.^2) / N;
    grad_b = sum(2 * errors .* x) / N;
    grad_c = sum(2 * errors .* y) / N;
    grad_e = sum(2 * errors) / N;
    
    % 파라미터 업데이트
    params(1) = params(1) - alpha * grad_a;
    params(2) = params(2) - alpha * grad_b;
    params(3) = params(3) - alpha * grad_c;
    params(4) = params(4) - alpha * grad_e;
    if(abs(Err0 - Err)/ Err * 100 < 0.03) break; end
    Err0 = Err;

    % 반복마다 결과 출력 (선택 사항)
    fprintf('Iteration %d: a = %.4f, b = %.4f, c = %.4f, e = %.4f Err = %.4f\n', ...
            iter, params(1), params(2), params(3), params(4), Err);
end

% 최종 결과 출력
fprintf('\nFinal fitted parameters:\n');
fprintf('a = %.4f\n', params(1));
fprintf('b = %.4f\n', params(2));
fprintf('c = %.4f\n', params(3));
fprintf('e = %.4f\n', params(4));

