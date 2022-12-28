function [dydx,d2ydx2]=diffeq(x,y)
n=length(x);%등간격인 x가 아니면 실행불가
if length(y)~=n,error('x and y must be same length');end
if any(diff(diff(x))~=0), error('unequal spacing'),end
if n<4,error('at least 4 datas required');end
dx=x(2)-x(1);
for i=1:n
    if i==1
        dydx(i)=(-y(i+2)+4*y(i+1)-3*y(i))/dx/2;
        d2ydx2(i)=(-y(i+3)+4*y(i+2)-5*y(i+1)+2*y(i))/dx^2;
    elseif i==n
        dydx(i)=(3*y(i)-4*y(i-1)+y(i-2))/dx/2;
        d2ydx2(i)=(-y(i-3)+4*y(i-2)-5*y(i-1)+2*y(i))/dx^2;
    else
        dydx(i)=(y(i+1)-y(i-1))/dx/2;
        d2ydx2(i)=(y(i+1)-2*y(i)+y(i-1))/dx^2;
    end
end
subplot(2,1,1);plot(x,dydx);grid;title('First derivatives')
subplot(2,1,2);plot(x,d2ydx2);grid;title('Second derivatives')
end