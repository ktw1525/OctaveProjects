function [x,y]=eulode(dydx,xi,xf,y0,h,varargin)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Euler법에 의해 미분방정식 dydt를 풀기위한 m파일. %
% xi,xf는 독립변수x의 구간이다.                   %
% y0는 x=xi일때의 종속변수y 값이다.(시작점)        %
% h는 반복계산 할때 x의 증가폭이다.(정확도와 관련)  %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if nargin<5,error('at least 5 input arguments required'),end
if ~(xf>xi),error('upper limit must be greater than lower'),end
x = (xi:h:xf)'; n = length(x);
% (xf-xi)/h가 정수가 아닐경우 x의 마지막 값이 xf가 아닐수 있다.
% 따라서 이경우에 x의 한 스탭을 더 넣어서 xf를 추가시킨다.
if x(n)<xf
    x(n+1) = xf;
    n = n+1;
end
y = y0*ones(n,1);
% Euler공식을 적용하여 y값을 구하는 과정이다.
for i = 1:n-1
    y(i+1) = y(i) + dydx(x(i),y(i),varargin{:})*(x(i+1)-x(i));
end
end