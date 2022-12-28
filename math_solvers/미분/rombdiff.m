function [d,ea,iter]=rombdiff(func,a,es,maxit,varargin)
if nargin<2,error('at least 2 input arguments required'),end
if nargin<3|isempty(es),es=0.000001;end
if nargin<4|isempty(maxit),maxit=50;end
n=1;
D(1,1) = diffd2(func,a,n,varargin{:});
iter=0;
while iter<maxit
    iter=iter+1;
    n=2^iter;
    D(iter+1,1)=diffd2(func,a,n,varargin{:});
    for k = 2:iter+1
        j=2+iter-k;
        D(j,k)=(4^(k-1)*D(j+1,k-1)-D(j,k-1))/(4^(k-1)-1);
    end
    ea=abs((D(1,iter+1)-D(2,iter))/D(1,iter+1))*100;
    if ea<=es, break; end
end
D
d=D(1,iter+1);
end
function d = diffd2(func,a,n,varargin)
x0 = a - a/n;
x1 = a + a/n;
d = (func(x1,varargin{:})-func(x0,varargin{:}))/(x1-x0);
end
