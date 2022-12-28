function DN = discardN(F,n) %F를 자리수n개만 남기고 버린다
k = floor(log(F)/log(10))
DN = floor(F*10^(-1*k+n))*10^(k-n)
end