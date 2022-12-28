function Taylor0ton(Y, h, u, n, x0) %h에대한 함수Y를 u기준으로 x = x0일때
                                    % 0부터 n차까지 Taylor급수
syms x % 변수 x를 선언
Y = subs(Y,h,x); %함수Y에서 h대신 x로 대체(변수의 어느 문자든 관계없게 함)
i = 0; %카운터 i 선언
t0 = subs(Y,x,x0);
while i <= n
T = Taylor(Y, x, u, i); % x를 파라미터로 갖는 
                        % 함수Y의 0을 기준으로한 Taylor급수를
                        % i차식으로 저장.
T %화면에 현재 i차 Taylor급수를 표현
t1 = subs(T, x, x0); %Taylor급수에 x0를 대입하여 계산후 t1에 저장.
et = (t0 - t1); %참 백분율 상대오차 ea 계산.
fprintf(' => x = %f => %f, et = %f\n', x0, t1, et) %출력
i = i+1; %카운트
end
