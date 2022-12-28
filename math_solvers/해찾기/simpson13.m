function I=simpson13(x,func,m)
%m개 구간에서의 simpson1/3 적분
if length(func)~=length(x)
    if nargin<3|isempty(m),m=2;end
    if length(x)~=2,error('size of x must be 2'); end
    if m<2,error('size of x must be bigger than 2'); end
    h = (x(2)-x(1))/m;
    xx = linspace(x(1),x(2),m+1);
    yy = func(xx);
    I=0;
    for i=1:2:m-1
    I=I+h*(yy(i)+4*yy(i+1)+yy(i+2))/3;
    end
else
    if nargin<3|isempty(m), m=length(x)-1;end
    m=length(x)-1;
    if length(x)<3,error('size of x must bigger than 2'); end
    I=0;
    for i=1:2:m-1
    I=I+(x(i+1)-x(i))*(func(i)+4*func(i+1)+func(i+2))/3;
    end
end
end