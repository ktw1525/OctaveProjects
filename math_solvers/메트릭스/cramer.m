function X = cramer(A,B)
% Cramer공식을 이용한 연립방정식 솔루션
[m, n] = size(A);
if ~(m==n),error('A가 정방행렬이 아닙니다.');end
if ~(size(B)==[m,1]),error('메트릭스 사이즈 오류');end
D=det(A);
for i = 1:n
    Atemp = A;
    Atemp(:,i) = B;
    X(i,1)=det(Atemp)/D;
end
end