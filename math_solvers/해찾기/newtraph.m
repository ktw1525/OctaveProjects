function [root,ea,iter] = newtraph(func,dfunc,xr,es,maxit,varargin)
% newtraph: Newton-Raphson���� ���� ��ã��
%   [root,ea,iter]=newtraph(func,dfunc,xr,es,maxit,p1,p2,...):
%       Newton-Raphson������ func�� ���� ã�´�.
% Input : 
%   func = ��� �Լ�
%   dfunc = ��� �Լ��� ���Լ�
%   xr = �� ���� ���۰�
%   es = �䱸�Ǵ� �ִ� ������
%   maxit = ��� �ݺ�����
%   p1,p2,... = ����Լ��� ������ ������ ��
% Output :
%   root = �Ǳ�
%   ea = �뷫���� ������
%   iter = �ݺ�Ƚ��
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