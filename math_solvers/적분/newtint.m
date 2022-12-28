function [yint A err] = newtint(x,y,xx,k)
n = length(x);
if length(y)~=n, error('x and y must be sasme length'); end
if nargin<2,error('at least 2 input arguments required'),end
if nargin<3|isempty(xx),xx = 0; end
if nargin<4|isempty(k),k = (n-1); end
b = zeros(n,n);
b(:,1)=y(:);
for j =2:n
    for i = 1:n-j+1
        b(i,j) = (b(i+1,j-1)-b(i,j-1))/(x(i+j-1)-x(i));
    end
end
A = b(1,:)';
xt=1;
yint = zeros(k,1);
err = zeros(length(yint)-1,1);
yinti = b(1,1);
for j = 1:k
    xt = xt*(xx-x(j));
    yinti = yinti + b(1,j+1)*xt;
    yint(j) = yinti;
    if j~=1, err(j-1)=yint(j)-yint(j-1); end
end
end
