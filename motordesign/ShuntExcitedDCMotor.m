clear; clf;
VtR=600;                      % Rated terminal voltage
PR=80;                        % Rated output horsepower
Ra=0.25;                      % Armature resistance
a=0.2; b=0.6e-5;              % F&W loss equation coefficients
nmR=1200;                     % Rated speed(rpm)
% Rated developed torque & armature current
TdR=PR*746/(nmR*pi/30)+(a+b*nmR^1.7)*30/pi; 
IaR=(VtR-sqrt(VtR^2-4*Ra*TdR*nmR*pi/30))/2/Ra;

load eif                      % Load stored OCC of Fig. 5-23
m=length(eif); npts=200;
Kphip=eif(1:m,1)/(nmR*pi/30); If=eif(1:m,2);

% Rated If
IfR=interp1( Kphip, If, (VtR-IaR*Ra)/(nmR*pi/30));
Rfeq=VtR/IfR;    % Total shunt field circuit resistance
npts=25; Ia=linspace(1.5*PR*746/VtR,0,npts);

% Determination of Td-nm
for i=1:npts
   Kphi=interp1(If, Kphip, IfR);
   Td(i)=Kphi*Ia(i);
   wm(i)=VtR/Kphi-Td(i)*Ra/Kphi^2; nm(i)=wm(i)*30/pi;
   Pfw=a*nm(i)+b*nm(i)^2.7;
   eff(i)=(1-(Pfw+Ia(i)^2*Ra+VtR*IfR)/(IfR+Ia(i))/VtR)*100;
   if eff(i)<0; m=i-1; break; end  % F&W over driving
end

subplot(2,1,1); plot(0,0,Td(1:m),nm(1:m),TdR,nmR,'o'); grid;
title('Shunt dc motor');
ylabel('Speed, rpm'); xlabel('Torque, N-m');
subplot(2,1,2); plot(0,0,Ia(1:m)+IfR,nm(1:m),IaR+IfR,nmR,'o'); grid;
title('Shunt dc motor');
ylabel('Speed, rpm'); xlabel('Line current, A');
figure(2)
subplot(2,1,1); plot(eff(1:m),nm(1:m)); grid;
title('Shunt dc motor');
ylabel('Speed, rpm'); xlabel('Efficiency, %');
