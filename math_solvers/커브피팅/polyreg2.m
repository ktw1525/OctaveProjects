function yy = polyreg2(x,y,xx,m,sw)
n=length(x);
if nargin<3, error('at least 3 input arguments required'), end
if nargin<4|isempty(m), m = n-1;end
if length(y)~=n, error('x and y must be same length'); end
if nargin<5|isempty(sw), sw = 0;end
for i = 1:m+1
    for j = 1:i
        k = i+j-2;
        s = 0;
        for l=1:n
            s = s+x(l)^k;
        end
        A(i,j)=s;
        A(j,i)=s;
    end
    s = 0;
    for l = 1:n
        s=s+y(l)*x(l)^(i-1);
    end
    b(i)=s;
end
p=A\b';
yy = zeros(size(xx));
res = zeros(size(x));
for i = 0:1:m
yy =  yy + p(i+1)*xx.^i;
res = res + p(i+1)*x.^i;
end
res = res - y;
if sw~=0
    subplot(2,1,1);plot(x,y,'ro',xx,yy,'b');
    xlabel('x'),ylabel('y'),title('Polynomial regression')
    subplot(2,1,2);plot(x,res,'o',x,res)
    xlabel('x'),ylabel('residual'),title('Residual Plot')
    grid on
end
end