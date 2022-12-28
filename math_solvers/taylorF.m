function T=taylorF(Y,t,x0,n)
syms x;
Y=subs(Y,t,x);
T=0;
for i=0:n
    df = diff(Y,x,i);
    df0 = subs(df,x,x0);
    sum = df0*(x-x0).^i/factorial(i);
    T = T+sum;
end
end