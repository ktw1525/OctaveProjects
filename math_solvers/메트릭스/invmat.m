function iA = invmat(A)
% A의 역행렬을 구한다.
N = size(A,1);
I = eye(N); %단위행렬
for i = 1:N
    iA(:,i) = LUsol(A,I(:,i));
end
end