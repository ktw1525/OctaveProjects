function y = simule(N1,N2,x,theta)

r=0.1;
l=0.118;
lh=0.02;

ud_cir = [x+linspace(-r,r,20),x+linspace(r,-r,20)]';
ud_stick_X = [x x+2*l*sin(theta)-lh*cos(theta) x+2*l*sin(theta)+lh*cos(theta)]';
ud_stick_Y = [r 2*l*cos(theta)+r+lh*sin(theta) 2*l*cos(theta)+r-lh*sin(theta)]';

set(N1, 'Xdata', ud_cir);
set(N2, 'Xdata', ud_stick_X,'Ydata', ud_stick_Y);
drawnow;

y = 1;