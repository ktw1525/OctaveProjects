function [x, ea, iter]= GSsol(A,B,X0,Es,maxiter)
% Gauss-Seidel 법을 이용하여 Ax=B의 x를 구한다.
if nargin<2, error('at least 2 input arguments required'), end
if size(A,1)~=size(A,2), error('Size of matrixs what you inputed is wrong.'), end
if size(A,1)~=size(B,1), error('Size of matrixs what you inputed is wrong.'), end
X0=X0(:);
if nargin<3|isempty(X0), X0 = zeros(size(B));end
if nargin<4|isempty(Es), Es = 0.0001;end
if nargin<5|isempty(maxiter), maxiter = 50;end
N=size(A,1); x=X0;
for iter=1:maxiter
    xold=x;
    for i=1:N
        x(i)=B(i)/A(i,i);
        for j=1:N
            if ~(j==i),x(i)=x(i)-A(i,j)*x(j)/A(i,i);
            end
        end
    end
    ea=max(abs((x-xold)./x*100));
    if ea<Es, break; end
end
end
