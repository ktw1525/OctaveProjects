function [L U] = LUbr(A)
% LU분해.
% A = LU, 에서 L과 U를 구함.
if size(A,1)~=size(A,2), error('A메트릭스 크기 에러'), end
N = size(A,1);
Xo = zeros(N,1);
% Upper Matrix 분해 Lower Matrix 분해
U = A; L = eye(N);
for i = 1:1:(N-1)
    for j = i+1:1:N
        L(j,i) = U(j,i)/U(i,i);
        U(j,:) = U(j,:)-U(i,:)*U(j,i)/U(i,i);
    end
end
end
