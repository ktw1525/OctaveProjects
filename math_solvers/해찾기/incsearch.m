function xb = incsearch(func,xmin,xmax,ns)
% incsearch : 
% xb = incsearch(func,xmin,xmax,ns) :
%   (xmin,xmax)���� ���� �Լ��� ���� x�� ���Ͽ� ��ȣ�� ���ϴ�
%   ������ ���Ѵ�.
% Input :
%   func = ��� �Լ�
%   xmin , xmin = ���� �����
%   ns = �������� ���� ���� (default = 50)
% Output :
%   xb(k,1)�� ��ȣ�� �ٲ�� ���� ������
%   xb(k,2)�� ��ȣ�� �ٲ�� ���� ����
%   ���� ��ȣ�� �ٲ�� ������ ���ٸ� xb = [] �̴�.   

if nargin < 4, ns = 50; end % ���� ns�� ��� �ִٸ� 50���� �ʱ�ȭ
% Incremental search
x = linspace(xmin,xmax,ns);
f = func(x);
nb = 0; xb = []; % ��ȣ�� �ٲ��� ������ xb�� Null�̴�.
for k =1:length(x)-1
    if sign(f(k)) ~= sign(f(k+1)) % ��ȣ�� �ٲ���� �˻�
        nb = nb + 1;
        xb(nb,1) = x(k);
        xb(nb,2) = x(k+1);
    end
end
if isempty(xb) % ��ȣ�� �ٲ�� ������ ã�� ���Ͽ����� ǥ��
    disp('no brackets found')
    disp('check interval or increase ns')
else
    disp('number of brackets:') % ã�� ������ ���� ǥ��
    disp(nb)
end