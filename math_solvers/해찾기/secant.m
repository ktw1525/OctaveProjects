function [root,E,iter] = secant(func,x0,x1,es,maxit,varargin)
% secant: secant method�� ���� ��ã��
%   [root,ea,iter]=secant(func,x0,x1,es,maxit,p1,p2,...):
%       �Ҽ������� func�� ���� ã�´�.
% Input : 
%   func = ��� �Լ�
%   x0 = �� ���� ���۰�(1)
%   x1 = �� ���� ���۰�(2)
%   es = �䱸�Ǵ� �ִ� ������
%   maxit = ��� �ݺ�����
%   p1,p2,... = ����Լ��� ������ ������ ��
% Output :
%   root = ������
%   ea = �뷫���� ������
%   iter = �ݺ�Ƚ��
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