clear all
close all
clc

f = 60;
w = 2*pi*f;
Vm = 220*sqrt(2);
t = 0:0.00001:0.05;
V = Vm*sin(w*t);
R0 = 5000;
R = rand(1,length(t)).^2*R0*10;

for i=1:1:length(t)
  if(abs(V(i))>45)
    R(i) = R0;
  end
end

I = V./R;
P = V.*I;
figure(1)
subplot(4,1,1);
plot(V)
subplot(4,1,2);
plot(R)
subplot(4,1,3);
plot(I)
subplot(4,1,4);
plot(P)
