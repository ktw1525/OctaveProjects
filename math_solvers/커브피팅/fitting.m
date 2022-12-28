function fittenfunc = fitting(X,Y,n)
% X와 Y를 받아 n차 식으로 Curve Fitting한다.
Xi = zeros(n+1,n+1);
Yi = zeros(n+1,1);
Xipart = zeros(2*n+1,1);
datanum = size(X,1);
A = [];
fittenfunc = 0;
syms x;
for j =  1:1:2*n+1
    for i = 1:1:datanum
        Xipart(j,1) = Xipart(j,1) + X(i,1)^(j-1);
        if j <= n+1
            Yi(j,1) = Yi(j,1) + Y(i,1)*X(i,1)^(j-1);
        end
    end
end
for j = 1:1:n+1
    for i = 1:1:n+1
        Xi(i,j) = Xipart(i+j-1,1);
    end
end
A = Xi^-1*Yi;
for i = 1:1:n+1
    fittenfunc = fittenfunc + x^(i-1)*A(i,1);
end
d = input('예측범위 : ');
X0 = X(1,1)-d:0.001*datanum:X(datanum,1)+d;
Y0 = subs(fittenfunc,x,X0);
plot(X,Y,'ro',X0,Y0,'b')
grid
end
        