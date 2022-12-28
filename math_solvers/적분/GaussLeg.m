function I=GaussLeg(func,a,b,n)
%Gauss-Legendre 공식 n점(n=1,2,3,4,5,6)
if nargin<3,error('at least 3 input arguments required'),end
if nargin<4|isempty(n),n=3;end
x = @(k) ((b+a)+(b-a)*k)/2;
t = (b-a)/2;
switch n
    case 1
        I = (2*func(x(0)))*t;
    case 2
        I = (func(x(-1/sqrt(3)))+func(x(1/sqrt(3))))*t;
    case 3
        I = (5/9*func(x(-1*sqrt(3/5)))+8/9*func(x(0))+5/9*func(x(sqrt(3/5))))*t;
    case 4
        c0 = (18-sqrt(30))/36; c1 = (18+sqrt(30))/36;
        c2 = (18+sqrt(30))/36; c3 = (18-sqrt(30))/36;
        x0 = -1*sqrt(525+70*sqrt(30))/35;
        x1 = -1*sqrt(525-70*sqrt(30))/35;
        x2 = sqrt(525-70*sqrt(30))/35;
        x3 = sqrt(525+70*sqrt(30))/35;
        I = (c0*func(x(x0))+c1*func(x(x1))+c2*func(x(x2))+c3*func(x(x3)))*t;
    case 5
        c0 = (322-13*sqrt(70))/900; c1 = (322+13*sqrt(70))/900; c2 = 128/225;
        c3 = (322+13*sqrt(70))/900; c4 = (322-13*sqrt(70))/900;
        x0 = -1*sqrt(245+14*sqrt(70))/21;
        x1 = -1*sqrt(245-14*sqrt(70))/21;
        x2 = 0;
        x3 = sqrt(245-14*sqrt(70))/21;
        x4 = sqrt(245+14*sqrt(70))/21;
        I = (c0*func(x(x0))+c1*func(x(x1))+c2*func(x(x2))+c3*func(x(x3))+c4*func(x(x4)))*t;
    case 6
        c0 = 0.171324492379170; c1 = 0.360761573048139; c2 = 0.467913934572691;
        c3 = 0.467913934572691; c4 = 0.360761573048139; c5 = 0.171324492379170;
        x0 = -0.932469514203152; x1 = -0.661209386466265;  x2 = -0.238619186083197;
        x3 = 0.238619186083197; x4 = 0.661209386466265; x5 = 0.932469514203152;
        I = (c0*func(x(x0))+c1*func(x(x1))+c2*func(x(x2))+c3*func(x(x3))+c4*func(x(x4))+c5*func(x(x5)))*t;
    otherwise
        I = (func(x(-1/sqrt(3)))+func(x(1/sqrt(3))))*t;
        disp('2점식 Gauss-Legendre')
end
end