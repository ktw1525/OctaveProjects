function Cmp = PtoC(Num,Grad) %�������� ���Ҽ����·κ�ȯ
Rad = Grad * 2 * pi / 360;
Cmp = Num*(cos(Rad)+j*sin(Rad));
end