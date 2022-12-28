function p = polyreg(x,y,m)
n=length(x);
if length(y)~=n, error('x and y must be same length'); end
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
xp = linspace(min(x), max(x),1000);
yp = zeros(size(xp));
res = zeros(size(x));
for i = 0:1:m
yp =  yp + p(i+1)*xp.^i;
res = res + p(i+1)*x.^i;
end
res = res - y;
subplot(2,1,1);plot(x,y,'ro',xp,yp,'b');
xlabel('x'),ylabel('y'),title('Polynomial regression')
subplot(2,1,2);plot(x,res,'o',x,res)
xlabel('x'),ylabel('residual'),title('Residual Plot')
grid on
end