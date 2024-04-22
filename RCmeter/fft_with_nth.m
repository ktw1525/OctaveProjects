function ret = fft_with_nth(data)
  len = length(data);
  n = 1:1:len;
  As = [];
  Bs = [];
  for nth=0:1:floor(len/2)
    sn = sin(2*pi/len*nth*n);
    cs = cos(2*pi/len*nth*n);
    A = 0;
    B = 0;
    for m=n
       A += data(m)*sn(m)/len*2;
       B += data(m)*cs(m)/len*2;
    endfor
    As = [As A];
    Bs = [Bs B];
    ret = [As; Bs];    
  endfor
endfunction