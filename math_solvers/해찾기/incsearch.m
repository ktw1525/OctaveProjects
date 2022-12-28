function xb = incsearch(func,xmin,xmax,ns)
% incsearch : 
% xb = incsearch(func,xmin,xmax,ns) :
%   (xmin,xmax)구간 내의 함수가 변수 x에 대하여 부호가 변하는
%   구간을 구한다.
% Input :
%   func = 대상 함수
%   xmin , xmin = 구간 경계점
%   ns = 부차적인 구간 개수 (default = 50)
% Output :
%   xb(k,1)은 부호가 바뀌는 구간 시작점
%   xb(k,2)은 부호가 바뀌는 구간 끝점
%   만약 부호가 바뀌는 구간이 없다면 xb = [] 이다.   

if nargin < 4, ns = 50; end % 만약 ns가 비어 있다면 50으로 초기화
% Incremental search
x = linspace(xmin,xmax,ns);
f = func(x);
nb = 0; xb = []; % 부호가 바뀌지 않으면 xb는 Null이다.
for k =1:length(x)-1
    if sign(f(k)) ~= sign(f(k+1)) % 부호가 바뀌는지 검사
        nb = nb + 1;
        xb(nb,1) = x(k);
        xb(nb,2) = x(k+1);
    end
end
if isempty(xb) % 부호가 바뀌는 구간을 찾지 못하였음을 표시
    disp('no brackets found')
    disp('check interval or increase ns')
else
    disp('number of brackets:') % 찾은 구간의 개수 표시
    disp(nb)
end