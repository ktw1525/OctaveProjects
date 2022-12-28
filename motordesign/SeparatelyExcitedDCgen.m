clear; clf;
VtR=600;      % Rated terminal voltage
 PR=60e03;     % Rated output power
 Ra=0.25;      % Armature resistance
 IaR=PR/VtR;   % Rated output current
 load eif      % Load stored OCC
 m=length(eif); 
 npts=200;
 E=eif(1:m,1); 
 If=eif(1:m,2);
 
% Determine E & If at rated condition
IfR=interp1( E, If, VtR+IaR*Ra); 
ER=interp1(If, E, IfR);
Ia=linspace(0,1.5*IaR,npts);

Vt=ER-Ia(1:npts)*Ra;
 
plot(0,0,Ia,Vt,IaR,VtR,'o'); grid;
title('Separately excited dc generator');
xlabel('Load current, A'); ylabel('Terminal voltage, V');
