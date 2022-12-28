function [Xo U L] = cholsol(A,B)
% Cholesky���ع����� ������������ Ǫ�� �ַ��, cholb.m, mtran.m�� ���� ���.
% A(xo) = B, A=mtran(U)*U ���� Xo�� ����.
if nargin<2, error('at least 2 input arguments required'), end
if size(A,1)~=size(A,2), error('Size of matrixs what you inputed is wrong.'), end
if size(A,1)~=size(B,1), error('Size of matrixs what you inputed is wrong.'), end
N = size(A,1); Xo = zeros(N,1);
% Cholesky Matrix ����
U=cholbr(A); L = mtran(U); Lt = L; Ut = U;
%��������
for i = 1:1:N
    Z(i,1) = B(i,1)/Lt(i,i);
    for j = i+1:1:N
        B(j,1) = B(j,1)-Lt(j,i)*Z(i,1);
        Lt(j,i) = 0;        
    end
end    
%��������
for i = N:-1:1
    Xo(i,1) = Z(i,1)/Ut(i,i);
    for j = N-1:-1:1
        Z(j,1) = Z(j,1)-Ut(j,i)*Xo(i,1);
        Ut(j,i) = 0;        
    end
end    
end