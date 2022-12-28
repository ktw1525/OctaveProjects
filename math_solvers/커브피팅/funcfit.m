function func = funcfit(filename,n)
datas = load(filename);
A = [];
Xi = [];
xipart = zeros(2*n+1,1);
yipart = zeros(n+1,1);
datanum = size(datas,1);
func = 0;
syms x;
for j=1:1:2*n+1
for i=1:1:datanum
    xipart(j) = xipart(j) + datas(i,1)^(j-1);
    if j <= n+1
        yipart(j) = yipart(j) + datas(i,2)*datas(i,1)^(j-1);
    end
end
end
for j=1:1:n+1
for i=1:1:n+1
    Xi(i,j) = xipart(i+j-1);
end
Yi(j,1) = yipart(j);
end
A = (Xi^-1)*Yi;
for i = 1:1:n+1
    func = func + A(i,1)*x^(i-1);
end
X0 = datas(:,1);
Y0 = datas(:,2);
d = input('출력할 본래 데이터보다 그래프 범위를 얼마나 넓히겠습니까?');
X01 = datas(1,1)-d:0.0001:datas(datanum,1)+d;
Y01 = subs(func,x,X01);
plot(X0,Y0,'ro',X01,Y01,'b');
grid
end
