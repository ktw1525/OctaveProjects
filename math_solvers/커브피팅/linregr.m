function [a, r2, syx] = linregr(x,y)
n = length(x);
if length(y) ~=n, error('x and y must be same legth'); end
x = x(:); y = y(:);
sx = sum(x); sy = sum(y);
sx2 = sum(x.^2); sxy = sum(x.*y); sy2 = sum(y.^2);
a(1) = (n*sxy-sx*sy)/(n*sx2-sx^2);
a(2) = sy/n-a(1)*sx/n;
a(2) = 0;
syx = sqrt(sum((y-a(1)*x-a(2)).^2)/(n-2));
r2 = ((n*sxy-sx*sy)/sqrt(n*sx2-sx^2)/sqrt(n*sy2-sy^2))^2;
xp = linspace(min(x), max(x), 2);
yp = a(1)*xp+a(2);
res = a(1)*x+a(2)-y;
subplot(2,1,1);plot(x,y,'o',xp,yp)
xlabel('x'),ylabel('y'),title('Linear Least-Squares Fit')
subplot(2,1,2);plot(x,res,'o',x,res)
xlabel('x'),ylabel('residual'),title('Residual Plot')
grid on
end