function I=trapeint(x,func,m)
%m�� ���������� ��ٸ��� ����
if length(func)~=length(x)
    %func�� ������ ���� [f=@(x)]
    if nargin<3|isempty(m), m=1;end
    if length(x)~=2,error('size of x must be 2'); end
    if m<1,error('size of x must be bigger than 1'); end
    h = (x(2)-x(1))/m;
    xx = linspace(x(1),x(2),m+1);
    yy = func(xx);
    I=0;
    for i=1:m
    I=I+h*(yy(i)+yy(i+1))/2;
    end
else
    if nargin<3|isempty(m), m=length(x)-1;end
    m=length(x)-1;
    if length(x)<2,error('size of x must bigger than 1'); end
    I=0;
    for i=1:m
    I=I+(x(i+1)-x(i))*(func(i)+func(i+1))/2;
    end
end
