function T=mtran(A)
% A��Ʈ������ ��ġ��ķ� �ٲپ� T�� ��ȯ�ϴ� �Լ�.
[m,n]=size(A);
for i = 1:n
    for j = 1:m
        T(i,j)=A(j,i);
    end
end
end