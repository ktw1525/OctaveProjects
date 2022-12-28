clear; clf;
VtR=600;      % Rated terminal voltage
PR=60e03;     % Rated output power
nmR=1200;     % Rated speed
Ra=0.25;      % Armature resistance
Rs=0.03;      % Series field resistance
Ns=10;        % Series field turns
IaR=PR/VtR;   % Rated output current
load eif   % Load stored OCC(in shunt field amps) for speed nmR
m=length(eif); 
npts=200;
E=eif(1:m,1); If=eif(1:m,2);
% Create Kphip & mmfs arrays
Kphip=eif(1:m,1)/(nmR*pi/30);
mmfs=eif(1:m,2)*Ns*IaR/(interp1(E,If,VtR+IaR*(Ra+Rs)));
npts=200; 
Ia=linspace(0,1.5*IaR,npts);
for i=1:npts      % Determine Vt-IL values
    Vt(i)=interp1(mmfs, Kphip, Ns*Ia(i))*nmR*pi/30-Ia(i)*(Ra+Rs);
end
plot(Ia,Vt,IaR,VtR,'o'); grid;
title('Series excited dc generator');
xlabel('Load current, A'); ylabel('Terminal voltage, V');
