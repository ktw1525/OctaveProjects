function Xo = Gauss(A,B)
%가우스 소거법으로 연립방정식을 푸는 솔루션 (A*Xo=B) 에서 Xo를 구함.
if nargin<2, error('at least 2 input arguments required'), end
if size(A,1)~=size(A,2), error('Size of matrixs what you inputed is wrong.'), end
if size(A,1)~=size(B,1), error('Size of matrixs what you inputed is wrong.'), end
N = size(A,1);
Xo = zeros(N,1);
%전진소거
for i = 1:1:(N-1)
    for j = i+1:1:N
        B(j,:) = B(j,:)-B(i,:)*A(j,i)/A(i,i);
        A(j,:) = A(j,:)-A(i,:)*A(j,i)/A(i,i);
    end
end
%후진대입
for i = N:-1:1
    Xo(i,1) = B(i,1)/A(i,i);
    for j = N-1:-1:1
        B(j,1) = B(j,1)-A(j,i)*Xo(i,1);
        A(j,i) = 0;        
    end
end    
end