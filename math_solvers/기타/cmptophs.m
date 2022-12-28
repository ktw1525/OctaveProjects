function phs = CmptoPhs(CM) %복소수에서 페이저로변환
Re = real(CM);
Im = imag(CM);
x = sqrt(Re^2 + Im^2);
y = atan(Im/Re)*360/2/pi;
phs = [x, y];
fprintf('\t= %f∠%f\n', x, y);
end