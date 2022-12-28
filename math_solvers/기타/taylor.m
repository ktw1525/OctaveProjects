function taylor_func = taylor(func,x0,pn,varargin)
% taylor : taylor�޼��� ����� �Լ�
% Input :
%   func = ����Լ�
%   x0 = ������
%   pn = �ְ�����
%   varargin = ������ ������ ��
% Output :
%   taylor_func = ���Ϸ��޼� ���
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



