t = 0:0.00001:0.05;
w = 2*pi*60;
V = 220*sqrt(2)*sin(w*t) + 25*sqrt(2)*sin(3*w*t) + 15*sqrt(2)*sin(5*w*t);

plot(t,V);