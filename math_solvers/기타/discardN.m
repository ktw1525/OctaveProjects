function DN = discardN(F,n) %F�� �ڸ���n���� ����� ������
k = floor(log(F)/log(10))
DN = floor(F*10^(-1*k+n))*10^(k-n)
end