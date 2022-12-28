function [root,E,iter] = secant(func,x0,x1,es,maxit,varargin)
% secant: secant method에 의한 근찾기
%   [root,ea,iter]=secant(func,x0,x1,es,maxit,p1,p2,...):
%       할선법으로 func의 근을 찾는다.
% Input : 
%   func = 대상 함수
%   x0 = 근 추적 시작값(1)
%   x1 = 근 추적 시작값(2)
%   es = 요구되는 최대 상대오차
%   maxit = 허용 반복개수
%   p1,p2,... = 대상함수의 나머지 변수들 값
% Output :
%   root = 추정근
%   ea = 대략적인 상대오차
%   iter = 반복횟수
if nargin<3,error('at least 3 input arguments required'),end
if nargin<4|isempty(es),es = 0.0001;end
if nargin<5|isempty(maxit),maxit = 50;end
iter = 0;
x2 = x1;

while(1)
    x2old = x2;
    x2 = x1 - func(x1)*(x0-x1)/(func(x0)-func(x1));
    x0 = x1;
    x1 = x2;
    iter = iter + 1;
    if x2~=0,ea=abs((x2-x2old)/x2)*100;end
    root(iter)=x2;
    E(iter)=ea;
    if ea<=es | iter >= maxit,break,end
end