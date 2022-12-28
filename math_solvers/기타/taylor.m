function taylor_func = taylor(func,x0,pn,varargin)
% taylor : taylor급수를 만드는 함수
% Input :
%   func = 대상함수
%   x0 = 기준점
%   pn = 최고차수
%   varargin = 나머지 변수들 값
% Output :
%   taylor_func = 테일러급수 출력
if nargin < 2|isempty(x0), x0 = 0, end
if nargin < 3|isempty(pn), pn = 1, end
syms x;
f0 = func(x,varargin{:});
taylor_func = 0;
for i = 0 : 1 : pn
    taylor_func = taylor_func + subs(f0,x,x0)*(x-x0)^i/factorial(i);
    f0 = diff(f0,x);
end
end



