function [A,B] = separateFreq(nth,data,oneCycleLen)  
  A = 0;
  B = 0;
  for i=1:1:oneCycleLen
    A = A + data(i)*sin(2*pi/oneCycleLen*nth*i);
    B = B + data(i)*cos(2*pi/oneCycleLen*nth*i);
  endfor
  A = A * sqrt(2)/oneCycleLen;
  B = B * sqrt(2)/oneCycleLen;
endfunction