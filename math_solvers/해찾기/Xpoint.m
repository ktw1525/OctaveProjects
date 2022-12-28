function [root,er] = Xpoint(func,xr,es,maxit)
iter = 0;
while (iter < maxit)
    iter = iter+1;
    xrold = xr;
    xr=func(xr);
    ea=abs((xr - xrold)/xr)*100;
    root(iter) = xr; 
    er(iter) = ea;
    if ea <= es | iter >= maxit,break,end
end
end
