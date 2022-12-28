function [yy,a,b,c,dy,d2]=natspline(x,y,xx,sw)
if nargin<3, error('at least 3 input arguments required'), end
if nargin<4|isempty(sw), sw = 0;end
n = length(x);
if length(y)~=n, error('x and y must be same length'); end
if any(diff(x)<=0), error('x not strictly ascending'), end
m = length(xx);
b = zeros(n,1);
aa(1,1)=1; aa(n,n)=1;
bb(1)=0; bb(n)=0;
for i=2:n-1
    aa(i,i-1)=h(x,i-1);
    aa(i,i)=2*(h(x,i-1)+h(x,i));
    aa(i,i+1)=h(x,i);
    bb(i)=3*(fd(i+1,i,x,y)-fd(i,i-1,x,y));
end
c=aa\bb';
a = y';
d = zeros(size(c));
for i = 1:n-1
    b(i)=fd(i+1,i,x,y)-h(x,i)/3*(2*c(i)+c(i+1));
    d(i)=(c(i+1)-c(i))/3/h(x,i);
    for i = 1:m
        [yy(i),dy(i),d2(i)] = SplineInterp(x,n,a,b,c,d,xx(i));
    end
end
function hh = h(x,i)
hh = x(i+1)-x(i);
end
function fdd = fd(i,j,x,y)
    fdd = (y(i)-y(j))/(x(i)-x(j));
end
function [yyy,dyy,d2y]=SplineInterp(x,n,a,b,c,d,xi)
    for ii=1:n-1
        if xi>=x(ii)-0.000001&xi<=x(ii+1)+0.000001
            yyy=a(ii)+b(ii)*(xi-x(ii))+c(ii)*(xi-x(ii))^2+d(ii)*(xi-x(ii))^3;
            dyy=b(ii)+2*c(ii)*(xi-x(ii))+3*d(ii)*(xi-x(ii))^2;
            d2y=2*c(ii)+6*d(ii)*(xi-x(ii));
            break
        end
    end
end
%그래프 그리기
if sw ~= 0
    fprintf('구간 \t a \t\t\t b \t\t\t c \t\t\t d \n')
    for i=1:n
    fprintf('%d \t\t %0.4f \t %0.4f \t %0.4f \t %0.4f \n',i,a(i),b(i),c(i),d(i))
    end
    plot(x,y,'o',xx,yy)
    grid
end
end