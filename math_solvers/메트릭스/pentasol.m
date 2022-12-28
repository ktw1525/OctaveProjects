function x=pentasol(A,b)
% 5�ߴ밢 �ý����� �ظ� ���ϴ� �ַ��
[m,n]=size(A);
if m~=n,error('A��Ʈ���� ������ ����.');end
if length(b)~=m,error('b��Ʈ���� ������ ����.');end
x = zeros(n,1);
% 5�ߴ밢 �ý����� �밢 ���� �и�
d=[0;0;diag(A,-2)]; G=zeros(n-2,1);
e=[0;diag(A,-1)];   E=zeros(n-1,1);
f=diag(A);          A=zeros(n,1);
g=diag(A,1);        D=zeros(n,1);
h=diag(A,2);
c = zeros(n,1);     z = zeros(n,1);
% ���к���
D(1)=f(1);
E(1)=g(1)/D(1);
G(1)=h(1)/D(1);
A(2)=e(2);
D(2)=f(2)-A(2)*E(1);
E(2)=(g(2)-A(2)*G(1))/D(2);
G(2)=h(2)/D(2);
for k=3:n-2
    A(k)=e(k)-d(k)*E(k-2);
    D(k)=f(k)-d(k)*G(k-2)-A(k)*E(k-1);
    E(k)=(g(k)-A(k)*G(k-1))/D(k);
    G(k)=h(k)/D(k);
end
A(n-1)=e(n-1)-d(n-1)*E(n-3);
D(n-1)=f(n-1)-d(n-1)*G(n-3)-A(n-1)*E(n-2);
E(n-1)=(g(n-1)-A(n-1)*G(n-2))/D(n-1);
A(n)=e(n)-d(n)*E(n-2);
D(n)=f(n)-d(n)*G(n-2)-A(n)*E(n-1);
% ��������
c(1)=b(1)/D(1);
c(2)=(b(2)-A(2)*c(1))/D(2);
for k=3:n
    c(k)=(b(k)-d(k)*c(k-2)-A(k)*c(k-1))/D(k);
end
% ��������
x(n)=c(n);
x(n-1)=c(n-1)-E(n-1)*x(n);
for k=n-2:-1:1
    x(k)=c(k)-E(k)*x(k+1)-G(k)*x(k+2);
end
end