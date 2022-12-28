function [dydx,d2ydx2]=diffeq2(x,y)
n=length(x);
if length(y)~=n,error('x and y must be same length');end
if n<2,error('at least 2 datas required');end
for i=1:n
    if i==1
        dydx(i)=richar(x(i),x(i),x(i+1),x(i+2),y(i),y(i+1),y(i+2));
    elseif i==n
        dydx(i)=richar(x(i),x(i-2),x(i-1),x(i),y(i-2),y(i-1),y(i));
    else
        dydx(i)=richar(x(i),x(i-1),x(i),x(i+1),y(i-1),y(i),y(i+1));
    end
end
y=dydx;
for i=1:n
    if i==1
        d2ydx2(i)=richar(x(i),x(i),x(i+1),x(i+2),y(i),y(i+1),y(i+2));
    elseif i==n
        d2ydx2(i)=richar(x(i),x(i-2),x(i-1),x(i),y(i-2),y(i-1),y(i));
    else
        d2ydx2(i)=richar(x(i),x(i-1),x(i),x(i+1),y(i-1),y(i),y(i+1));
    end
end
subplot(2,1,1);plot(x,dydx);grid;title('First derivatives')
subplot(2,1,2);plot(x,d2ydx2);grid;title('Second derivatives')
end

function D = richar(xx,x0,x1,x2,y0,y1,y2)
D=y0*(2*xx-x1-x2)/(x0-x1)/(x0-x2);
D=D+y1*(2*xx-x0-x2)/(x1-x0)/(x1-x2);
D=D+y2*(2*xx-x0-x1)/(x2-x0)/(x2-x1);
end