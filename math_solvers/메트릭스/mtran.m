function T=mtran(A)
% A메트릭스를 전치행렬로 바꾸어 T로 반환하는 함수.
[m,n]=size(A);
for i = 1:n
    for j = 1:m
        T(i,j)=A(j,i);
    end
end
end