function [Xr,Yr] = transformationVector(X0,Y0,Xref,Yref)
  Vref = sqrt(Xref^2 + Yref^2);
  Xr = (X0*Xref + Y0*Yref)/Vref;
  Yr = (Y0*Xref - X0*Yref)/Vref;
endfunction