function x4= bogan2nd(func,x1,x2,x3,m)
% 2차 보간법으로 최적점 구하기.
y1 = func(x1);
y2 = func(x2);
y3 = func(x3);
x4 = x2-((x2-x1)^2*(y2-y3)-(x2-x3)^2*(y2-y1))/2/((x2-x1)*(y2-y3)-(x2-x3)*(y2-y1));
x4old = x4;
if m>1
    xtemp = [x1 x2 x3 x4];
    xtemp = sort(xtemp);
    if xtemp(1)==x4 % 다음 계산시에는 x1 x2 x3이 크기순으로 정렬되도록 함.
        x1 = xtemp(1); x2 = xtemp(2); x3 = xtemp(3);
    else
        x1 = xtemp(2); x2 = xtemp(3); x3 = xtemp(4);
    end
    x4 = bogan2nd(func,x1,x2,x3,m-1); % 다시 함수를 불러내어 반복계산.
end
end