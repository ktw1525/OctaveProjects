function root=FPos(F,xi,xf,ea)
E=ea*2;
X=xi;
while E >= ea/100;
    Xold=X;
    X=xi-F(xi)*(xf-xi)/(F(xf)-F(xi));
    if F(X)*F(xi)<0 xf=X;
    else xi=X;
    end
    E = abs((X-Xold)/X);
end
root = X;
end