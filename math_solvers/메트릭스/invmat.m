function iA = invmat(A)
% A�� ������� ���Ѵ�.
N = size(A,1);
I = eye(N); %�������
for i = 1:N
    iA(:,i) = LUsol(A,I(:,i));
end
end