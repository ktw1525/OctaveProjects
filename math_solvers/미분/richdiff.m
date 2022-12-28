function D = richdiff(xx,x0,x1,x2,y0,y1,y2)
D=y0*(2*xx-x1-x2)/(x0-x1)/(x0-x2);
D=D+y1*(2*xx-x0-x2)/(x1-x0)/(x1-x2);
D=D+y2*(2*xx-x0-x1)/(x2-x0)/(x2-x1);
end