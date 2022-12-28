function [root,ea,iter] = fpointiter(func,xr,es,maxit,varargin)
% fpointiter: ������ �ݺ����� ���� ��ã��
%   [root,ea,iter]=fpointiter(func,dfunc,xr,es,maxit,p1,p2,...):
%       ������ �ݺ���(fixed-point iteration)���� func�� ���� ã�´�.
% Input : 
%   func = ��� �Լ�(������ �ݺ������� ���� ������ �Լ�)
%   xr = �� ���� ���۰�
%   es = �䱸�Ǵ� �ִ� ������
%   maxit = ��� �ݺ�����
%   p1,p2,... = ����Լ��� ������ ������ ��
% Output :
%   root = ������
%   ea = �뷫���� ������
%   iter = �ݺ�Ƚ��
if nargin<2,error('at least 2 input arguments required'),end
if nargin<3|isempty(es),es = 0.0001;end
if nargin<4|isempty(maxit),maxit = 50;end
iter = 0;
while(1)
    xrold = xr;
    xr = func(xr);
    iter = iter + 1;
    if xr~=0,ea=abs((xr-xrold)/xr)*100;end
    if ea<=es | iter >= maxit,break,end
end
root=xr;