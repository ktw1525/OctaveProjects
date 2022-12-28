function [x,y]=eulode2(dydx,xi,xf,y0,h,varargin)
if nargin<5,error('at least 5 input arguments required'),end
if ~(xf>xi),error('upper limit must be greater than lower'),end
% Euler법에 의해 dydt를 적분한 데이터 x,y를 구하는 함수.
% xi,xf는 독립변수x의 구간이다.
% y0는 x=xi일때의 종속변수y 값이다.
% h는 반복계산 할때 x의 증가폭이다.
x = (xi:h:xf)'; n = length(x);
% (xf-xi)/h가 정수가 아닐경우 x의 마지막 값이 xf가 아닐수 있다.
% 이경우에 x의 한 스탭을 더 넣어서 xf를 추가시킨다.
if x(n)<xf
    x(n+1) = xf;
    n = n+1;
end
y = ones(n,1)*y0;
% Euler공식을 적용하여 y값을 구하는 과정이다.
for i = 1:n-1
    y(i+1,:) = (y(i,:)' + dydx(x(i),y(i,:),varargin{:})*(x(i+1)-x(i)))';
end
end

%>> g = 9.81; R = 6.37*10^6;
%>> f = @(t,x) [-g*R^2./(R+x(:,2)).^2; x(:,1)];
%>> [t y] = eulode2(f, 0, 160, [1400 0], 10);
%>> plot(t,y(:,1))
%>> grid