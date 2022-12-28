function A = sinureg(x,y,T)
n=length(x);
if length(y)~=n, error('x and y must be same length'); end
x=x(:);
y=y(:);
w0 = 2*pi/T;
Z=[ones(size(x)) cos(w0*x) sin(w0*x)];
A=Z\y;
xp = linspace(min(x), max(x),1000);
yp = A(1) + A(2)*cos(w0*xp) + A(3)*sin(w0*xp);
res = y - A(1) - A(2)*cos(w0*x) - A(3)*sin(w0*x);
subplot(2,1,1);plot(x,y,'ro',xp,yp,'b');
xlabel('x'),ylabel('y'),title('Sinusoidal regression')
subplot(2,1,2);plot(x,res,'o',x,res)
xlabel('x'),ylabel('residual'),title('Residual Plot')
grid on
end