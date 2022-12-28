function [x,y]=heun(dydx,xi,xf,y0,h,es,iter,varargin)
if nargin<5,error('at least 5 input arguments required'),end
if nargin<6|isempty(es), es = 0.0001;end
if nargin<7|isempty(iter), iter = 50;end
if ~(xf>xi),error('upper limit must be greater than lower'),end
% Heun법에 의해 dydt를 적분한 데이터 x,y를 구하는 함수.
% xi,xf는 독립변수x의 구간이다.
% y0는 x=xi일때의 종속변수y 값이다.
% h는 반복계산 할때 x의 증가폭이다.
% es는 상대오차, iter는 반복회수 종료기준이다.
x = (xi:h:xf)'; n = length(x);
% (xf-xi)/h가 정수가 아닐경우 x의 마지막 값이 xf가 아닐수 있다.
% 이경우에 x의 한 스탭을 더 넣어서 xf를 추가시킨다.
if x(n)<xf
    x(n+1) = xf;
    n = n+1;
end
y = y0*ones(n,1);
% Heun공식을 적용하여 y값을 구하는 과정이다.
for i = 1:n-1
    f0 = dydx(x(i),y(i),varargin{:});
    y(i+1) = y(i) + f0*(x(i+1)-x(i));
    ea = es*2;
    while (ea>es)&(iter>0)
        yo = y(i+1);
        f1 = dydx(x(i+1),y(i+1),varargin{:});
        f = (f0 + f1)/2;
        y(i+1) = y(i)+f*(x(i+1)-x(i));
        ea = abs(yo - y(i+1))/y(i+1)*100;
        iter = iter-1;
    end
end
end