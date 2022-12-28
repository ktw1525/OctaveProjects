function Pr4_10(Y, h, x0, n) %h에대한 함수Y를 x = x0일때 유효숫자 n개가
                             %나올때까지 반복
syms x % 변수 x를 선언
Y = subs(Y,h,x); %함수Y에서 h대신 x로 대체(변수의 어느 문자든 관계없게 함)
es = 0.5 * 10^(2-n); % 유효숫자 n개인 최대 상대오차 판정기준
ea = es * 2; % 근사 백분율상대오차의 초기화...처음while을 통과하기 위한조건
truev = subs(Y,'x',x0); %Y에 x0를 대입한 참값.
fprintf('es = %f\n\n', es) %es = ???? 출력
i = 1; %카운터 i 선언
t0 = cos(x0); %t0는 앞으로 while안에서 Taylor급수를 계산한 이전근사값
T0 = 'Def'; %T0는 Taylor급수 T가 i의 증가에따라 변하지 않을경우 ea가
            % 0이 되는현상을 방지하기 위함.
while abs(ea) >= es
T = Taylor(Y, x, 0, i); % x를 파라미터로 갖는 
                        % 함수Y의 0을 기준으로한 Taylor급수를
                        % (i-1)차식으로 저장.
if(T == T0) %T가 변하지 않을경우
    i = i + 1; %i는 1증가시키고
    continue %밑의 과정을 뛰어넘고 while문 진행.
end
T0 = T; %T0에 지금 T값을 저장하고 그 다음 반복시 T와 비교하기 위함.
T %화면에 현재 (i-1)차 Taylor급수를 표현
t1 = subs(T, x, x0); %Taylor급수에 x0를 대입하여 계산후 t1에 저장.
ea = (t1 - t0) / t1 * 100; %근사 백분율 상대오차 ea 계산.
e = (truev- t1) / truev * 100;
fprintf(' => x=%f => %f, e = %f, ea = %f\n', x0, t1, e, ea) %출력
t0 = t1; %한번 돌아서 이전 근사값으로 쓰기위함.
i = i+1; %카운트
end
