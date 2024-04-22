function ret = revsfft(As, Bs, len)
  n = 1:1:len;
  ret = 0;
  for nth=0:1:length(As)-1
    ret += As(nth+1).*sin(2*pi/len*nth*n);
    ret += Bs(nth+1).*cos(2*pi/len*nth*n);
    if nth==0
      ret /= 2;
    endif
  endfor
endfunction