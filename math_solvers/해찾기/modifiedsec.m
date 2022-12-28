function [root,ea,iter] = modifiedsec(func,xr,de,es,maxit,varargin)
% modifiedsec: Modified secant method�� ���� ��ã��
%   [root,ea,iter]=modifiedsec(func,xr,de,maxit,p1,p2,...):
%       ������ �Ҽ������� func�� ���� ã�´�.
% Input : 
%   func = ��� �Լ�
%   xr = �� ���� ���۰�
%   de = ������(�ʹ������� �ݿø������� �þ�� �ʹ�ũ�� ��ȿ�����̴�)
%   es = �䱸�Ǵ� �ִ� ������
%   maxit = ��� �ݺ�����
%   p1,p2,... = ����Լ��� ������ ������ ��
% Output :
%   root = ������
%   ea = �뷫���� ������
%   iter = �ݺ�Ƚ��
if nargin<2,error('at least 2 input arguments required'),end
if nargin<3|isempty(de),de = 0.0001;end
if nargin<4|isempty(es),es = 0.0001;end
if nargin<5|isempty(maxit),maxit = 50;end
iter = 0;
while(1)
    xrold = xr;
    xr = xr - de*func(xr)/(func(xr*(1+de))-func(xr));
    iter = iter + 1;
    if xr~=0,ea=abs((xr-xrold)/xr)*100;end
    if ea<=es | iter >= maxit,break,end
end
root=xr;