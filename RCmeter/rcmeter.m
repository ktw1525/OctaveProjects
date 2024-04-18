clear all;
close all;
clc;

Cycl = 6;       # 주기 수
Len = 2000;     # 데이터 길이
Vp = 311;       # 전압 진폭
w = 2*pi*Cycl/Len;

n = linspace(1,Len,Len); # 샘플번호

V = Vp*sin(w*n);         # 측정 전압
dVdn = w*Vp*cos(w*n);
Rtrue = (100+n)*100;         # R 참 값
Ctrue = (Len - n)*10^-6;     # C 참 값
dCdn = -10^-6;

I = V./Rtrue + dVdn.*Ctrue + dCdn.*V;   # 측정 전류

figure(1);
subplot(2,1,1);
plot(n,V,'r', n,I*10000, 'b');
subplot(2,1,2);
plot(n, Rtrue/10000, 'r', n, Ctrue*10000, 'b');

# 입력 데이터
# 1) 전압 V, dVdn
# 2) 전류 I
# 출력 데이터
# 1) 컨덕턴스 Gr
# 2) 캐패시턴스 Cr
# 3) 오차율(참 값: G, C, 측정 값: Gr, Cr)

ag_r = 1;
bg_r = 1;
ac_r = 1;
bc_r = 1;

Gk = @(k,a,b) a*k + b;
Ck = @(k,a,b) a*k + b;
dCk = @(k,a,b) a;

Ik = @(k,ag,bg,ac,bc,v,i,dvdt) ( Gk(k,ag,bg) + dCk(k,ac,bc) )/v + Ck(k,ac,bc)*dvdt;


Mk = @(i) [ (i+0)*V(i+0) V(i+0) V(i+0)+(i+0)*dVdn(i+0) dVdn(i+0);
      (i+1)*V(i+1) V(i+1) V(i+1)+(i+1)*dVdn(i+1) dVdn(i+1);
      (i+2)*V(i+2) V(i+2) V(i+2)+(i+2)*dVdn(i+2) dVdn(i+2);
      (i+3)*V(i+3) V(i+3) V(i+3)+(i+3)*dVdn(i+3) dVdn(i+3); ]
bk = @(i) [ I(i); I(i+1); I(i+2); I(i+3); ];


inv(Mk(2))*bk(2)


