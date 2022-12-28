function root=fanning(func,xl,xu,varargin)
if nargin<3, error('at least 3 input arguments required'), end
test = func(xl,varargin{:})*func(xu,varargin{:});
if test>0, error('no sign change'), end
xr = xl;
dx = xu - xl;
for iter = 1:1:11
    xrold = xr;
    xr = (xl + xu)/2;
    Ea = dx*2^(-1*iter);
    test = func(xl,varargin{:})*func(xr,varargin{:});
    if test < 0
        xu = xr;
    elseif test > 0
        xl = xr;
    else
        Ea = 0;
    end   
end
root = xr;