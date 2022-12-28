function [x,y]=eulode(dydx,xi,xf,y0,h,varargin)
if nargin<5,error('at least 5 input arguments required'),end
if ~(xf>xi),error('upper limit must be greater than lower'),end
% Euler���� ���� dydt�� ������ ������ x,y�� ���ϴ� �Լ�.
% xi,xf�� ��������x�� �����̴�.
% y0�� x=xi�϶��� ���Ӻ���y ���̴�.
% h�� �ݺ���� �Ҷ� x�� �������̴�.
x = (xi:h:xf)'; n = length(x);
% (xf-xi)/h�� ������ �ƴҰ�� x�� ������ ���� xf�� �ƴҼ� �ִ�.
% �̰�쿡 x�� �� ������ �� �־ xf�� �߰���Ų��.
if x(n)<xf
    x(n+1) = xf;
    n = n+1;
end
y = y0*ones(n,1);
% Euler������ �����Ͽ� y���� ���ϴ� �����̴�.
for i = 1:n-1
    y(i+1) = y(i) + dydx(x(i),y(i),varargin{:})*(x(i+1)-x(i));
end
end