function I=simpson38(x,func,m)
%m개 구간에서의 simpson3/8 적분
if length(func)~=length(x)
    if nargin<3|isempty(m),m=3;end
    if length(x)~=2,error('size of x must be 2'); end
    if m<3,error('size of x must be bigger than 3'); end
    h = (x(2)-x(1))/m;
    xx = linspace(x(1),x(2),m+1);
    yy = func(xx);
    I=0;
    for i=1:m-2
    I=I+3*h*(yy(i)+3*yy(i+1)+3*yy(i+2)+yy(i+3))/8;
    end
else
    if nargin<3|isempty(m), m=length(x)-1;end
    m=length(x)-1;
    if length(x)<4,error('size of x must bigger than 3'); end
    I=0;
    for i=1:2:m-2
    I=I+3*(x(i+1)-x(i))*(func(i)+3*func(i+1)+3*func(i+2)+func(i+3))/8;
    end
end    
end