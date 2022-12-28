function dy = diffuneq(x,y)
if nargin<2,error('at least 2 input arguments required'),end
n=length(x);
for i = 1:n
    dy(i) = dyuneq(x,y,n,x(i));
end
end
function dydx = dyuneq(x,y,n,xx)
if xx<=x(2)
    dydx = DyDx(xx,x(1),x(2),x(3),y(1),y(2),y(3));
elseif xx>= x(n-1)
    dydx = DyDx(xx,x(n-2),x(n-1),x(n),y(n-2),y(n-1),y(n));
else
    for ii=2:n-2
        if xx>=x(ii)&xx<=x(ii+1)
            if xx-x(ii)<x(ii+1)-xx
                dydx = DyDx(xx,x(ii-1),x(ii),x(ii+1),y(ii-1),y(ii),y(ii+1));
            elseif xx-x(ii-1)==x(ii+1)-xx&x(ii)-x(ii-1)<x(ii+2)-x(ii+1)
                dydx = DyDx(xx,x(ii-1),x(ii),x(ii+1),y(ii-1),y(ii),y(ii+1));
            else
                dydx = DyDx(xx,x(ii),x(ii+1),x(ii+2),y(ii),y(ii+1),y(ii+2));
            end
            break
        end
    end
end
end

function dy = DyDx(x,x0,x1,x2,y0,y1,y2)
dy = y0*(2*x-x1-x2)/(x0-x1)/(x0-x2)+y1*(2*x-x0-x2)/(x1-x0)/(x1-x2)+y2*(2*x-x0-x1)/(x2-x0)/(x2-x1);
end
