function [Xo L U] = LUsol(A,B)
% LU분해법으로 연립방정식을 푸는 솔루션 LUbr.m 필요
% LU(Xo) = B, U(Xo) = Z, LZ = B 에서 Xo를 구함.
if nargin<2, error('at least 2 input arguments required'), end
if size(A,1)~=size(A,2), error('Size of matrixs what you inputed is wrong.'), end
if size(A,1)~=size(B,1), error('Size of matrixs what you inputed is wrong.'), end
N = size(A,1);
Xo = zeros(N,1);
% Upper Matrix 분해 Lower Matrix 분해
[L U] = LUbr(A); Lt = L; Ut = U;
%전진대입
for i = 1:1:N
    Z(i,1) = B(i,1)/Lt(i,i);
    for j = i+1:1:N
        B(j,1) = B(j,1)-Lt(j,i)*Z(i,1);
        Lt(j,i) = 0;        
    end
end    
%후진대입
for i = N:-1:1
    Xo(i,1) = Z(i,1)/Ut(i,i);
    for j = N-1:-1:1
        Z(j,1) = Z(j,1)-Ut(j,i)*Xo(i,1);
        Ut(j,i) = 0;        
    end
end    
end