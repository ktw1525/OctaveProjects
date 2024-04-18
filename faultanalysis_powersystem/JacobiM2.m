function [J11,J12,J21,J22] = JacobiM2(Ybus,V,A)
G = real(Ybus); % 컨덕턴스
B = imag(Ybus); % 서셉턴스
numtotal = length(V);
Ones = ones(numtotal,1);
dA = Ones*A' - A*Ones';
%J11
J11d = Ones*((V.*diag(G))'+sum((V*Ones').*(G.*cos(dA)+B.*sin(dA)))).*eye(numtotal);
J11n = (V*Ones').*(G.*cos(dA)+B.*sin(dA));
J11 = J11d + J11n - (Ones*diag(J11n)').*eye(numtotal);
%J12
J12d = Ones*(V'.*(sum((V*Ones').*(-G.*sin(dA)+B.*cos(dA)))-(V.*diag(B))')).*eye(numtotal);
J12n = V*V'.*(G.*sin(dA)-B.*cos(dA));
J12 = J12d + J12n - (Ones*diag(J12n)').*eye(numtotal);
%J21
J21d = Ones*((-V.*diag(B))'+sum((V*Ones').*(G.*sin(dA)-B.*cos(dA)))).*eye(numtotal);
J21n = (V*Ones').*(G.*sin(dA)-B.*cos(dA));
J21 = J21d + J21n - (Ones*diag(J21n)').*eye(numtotal);
%J22
J22d = Ones*(V'.*(sum((V*Ones')*(G.*cos(dA)+B.*sin(dA)))-(V.*diag(G))')).*eye(numtotal);
J22n = -V*V'.*(G.*cos(dA)+B.*sin(dA));
J22 = J22d + J22n - (Ones*diag(J22n)').*eye(numtotal);
end