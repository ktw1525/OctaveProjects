function U = cholbr(A)
% Cholesky����.
% A=mtran(U)*U ���� U�� ����.
if size(A,1)~=size(A,2), error('Size of matrixs what you inputed is wrong.'), end
N = size(A,1); Xo = zeros(N,1);
% Cholesky Matrix ����
for i = 1:1:N
    p=1; us=0;
    while(p<i)
        us = us + U(p,i)^2;
        p=p+1;
    end
    U(i,i) = sqrt(A(i,i)-us);
    for j = i+1:1:N
        p=1; us=0;
        while(p<i)
            us = us + U(p,i)*U(p,j);
            p=p+1;
        end
        U(i,j)=(A(i,j)-us)/U(i,i);
    end
end
end 