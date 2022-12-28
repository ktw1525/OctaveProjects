function [x,y]=heun(dydx,xi,xf,y0,h,es,iter,varargin)
if nargin<5,error('at least 5 input arguments required'),end
if nargin<6|isempty(es), es = 0.0001;end
if nargin<7|isempty(iter), iter = 50;end
if ~(xf>xi),error('upper limit must be greater than lower'),end
% Heun���� ���� dydt�� ������ ������ x,y�� ���ϴ� �Լ�.
% xi,xf�� ��������x�� �����̴�.
% y0�� x=xi�϶��� ���Ӻ���y ���̴�.
% h�� �ݺ���� �Ҷ� x�� �������̴�.
% es�� ������, iter�� �ݺ�ȸ�� ��������̴�.
x = (xi:h:xf)'; n = length(x);
% (xf-xi)/h�� ������ �ƴҰ�� x�� ������ ���� xf�� �ƴҼ� �ִ�.
% �̰�쿡 x�� �� ������ �� �־ xf�� �߰���Ų��.
if x(n)<xf
    x(n+1) = xf;
    n = n+1;
end
y = y0*ones(n,1);
% Heun������ �����Ͽ� y���� ���ϴ� �����̴�.
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