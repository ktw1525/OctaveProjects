function X = cramer(A,B)
% Cramer������ �̿��� ���������� �ַ��
[m, n] = size(A);
if ~(m==n),error('A�� ��������� �ƴմϴ�.');end
if ~(size(B)==[m,1]),error('��Ʈ���� ������ ����');end
D=det(A);
for i = 1:n
    Atemp = A;
    Atemp(:,i) = B;
    X(i,1)=det(Atemp)/D;
end
end