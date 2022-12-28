function Cmp = PtoC(Num,Grad) %페이저를 복소수형태로변환
Rad = Grad * 2 * pi / 360;
Cmp = Num*(cos(Rad)+j*sin(Rad));
end