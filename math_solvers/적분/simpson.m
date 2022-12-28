function I=simpson(x,y,k)
%m개 구간에서의 simpson1/3,3/8 적분
m = length(x);
for i =1:k
x1(i) = x(i);
y1(i) = y(i);
end
for i =1:m-k+1
x2(i) = x(k-1+i);
y2(i) = y(k-1+i);
end
I1 = simpson38(x1,y1);
I2 = simpson13(x2,y2);
I=I1+I2;
end