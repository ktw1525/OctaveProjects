function [root, ea, iter] = newfalsepos(func,xl,xu,es,imax,varargin)

if nargin<3, error('at least 3 input arguments required'), end
test = func(xl,varargin{:})*func(xu,varargin{:});
if test>0, error('no sign change'), end
if nargin<4|isempty(es), es = 0.0001;end
if nargin<5|isempty(imax), imax = 50;end

iter = 0;
fl = func(xl);
fu = func(xu);
xr = xu;
iu = 0;
il = 0;

while (1)
    iter=iter+1;
    xrold = xr;
    xr = xu - fu*(xl-xu) /(fl-fu);
    fr = func(xr);
    if xr ~= 0, ea = abs((xr-xrold)/xr)*100; end
    test = fl*fr;
    if test < 0
        xu = xr;
        fu = func(xu);
        iu = 0;
        il = il+1;
        if il >= 2, fl = fl/2; end
    elseif test > 0
        xl = xr;
        fl = func(xl);
        il = 0;
        iu = iu+1;
        if iu >= 2, fu = fu/2; end
    else
        ea = 0;
    end
    if ea<es|iter>=imax, break, end
end
root = xr;
end
