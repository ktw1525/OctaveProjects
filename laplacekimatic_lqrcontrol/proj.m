clear all
clc

syms m I M J th l r x Rm Kb nKt fm

m=2;
r=0.1;
I=0.18;
M=13;
l=0.118;
J=4.8;
Rm=0.1548;
Kb=0.4829/65*7;
nKt=0.0472*65/7*65/7;
fm=0.0014*65/7;
fw=0.003;
g=9.81;

a=nKt/2/Rm;
A=[M*l M*l^2+J;m+I/r^2+M M*l];
C=[Kb*a/r+fm/2/r -Kb*a-fm/2;a*Kb+fm/2+fw -r*a*Kb-r/2*fm];
G=[0 -M*g*l;0 0];
F=[a;r*a];

B=-inv(A)*C;
D=-inv(A)*G;
Q=inv(A)*F;

T=[0 0 1 0;
    0 0 0 1;
    D(1,1) D(1,2) B(1,1) B(1,2);
    D(2,1) D(2,2) B(2,1) B(2,2)]
Q=[0;0;Q]
Qr=diag([10 80 1 5])
R=1;
K=lqr(T,Q,Qr,R)

x1=[linspace(-r,r,20),linspace(r,-r,20)]';
y1=[sqrt(r^2-linspace(-r,r,20).^2)+r, r-sqrt(r^2-linspace(r,-r,20).^2)]';
x2=[0 -0.1*r 0.1*r]';
y2=[r r+2*l r+2*l]';

Cir=fill(x1,y1,'r');
hold on

Squ=fill(x2,y2,'b');

axis([-1 1 -1 1]);
hold off