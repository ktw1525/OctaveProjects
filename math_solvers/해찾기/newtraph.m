function [root,ea,iter] = newtraph(func,dfunc,xr,es,maxit,varargin)
% newtraph: Newton-Raphson법에 의한 근찾기
%   [root,ea,iter]=newtraph(func,dfunc,xr,es,maxit,p1,p2,...):
%       Newton-Raphson법으로 func의 근을 찾는다.
% Input : 
%   func = 대상 함수
%   dfunc = 대상 함수의 도함수
%   xr = 근 추적 시작값
%   es = 요구되는 최대 상대오차
%   maxit = 허용 반복개수
%   p1,p2,... = 대상함수의 나머지 변수들 값
% Output :
%   root = 실근
%   ea = 대략적인 상대오차
%   iter = 반복횟수
if nargin<3,error('at least 3 input arguments required'),end
if nargin<4|isempty(es),es = 0.0001;end
if nargin<5|isempty(maxit),maxit = 50;end
iter = 0;
while(1)
    xrold = xr;
    xr = xr - func(xr)/dfunc(xr);
    iter = iter + 1;
    if xr~=0,ea=abs((xr-xrold)/xr)*100;end
    if ea<=es | iter >= maxit,break,end
end
root=xr;