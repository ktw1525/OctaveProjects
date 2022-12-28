function funcm = invnewt(A,x,k,m)
n = length(x);
if nargin<2,error('at least 2 input arguments required'),end
if nargin<3|isempty(k),k = (n-1); end
syms u
xt= 1;
func = A(1);
for j = 1:k
    xt = xt*(u-x(j));
    func = func+xt*A(j+1);
end
funcm = subs(func,u,m);
end