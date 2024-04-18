function [P Q] = PWCal(Y,Vmag,A)
V=Vmag.*(cos(A)+sin(A)*i); % V = Vmag∠θ
S=V.*conj(Y*V); % S = V.*conj(I)
P=real(S);
Q=imag(S);
end
