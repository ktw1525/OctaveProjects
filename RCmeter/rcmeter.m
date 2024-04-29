clear all;
close all;
clc;

Cycl = 6;       # 주기 수
Len = 2000;     # 데이터 길이
Vp = 311;       # 전압 진폭
w = 2*pi*Cycl/Len;

n = linspace(1,Len,Len); # 샘플번호

ag_t = 0.01
bg_t = 0.01
ac_t = 10^-6
bc_t = 10^-6

V = Vp*sin(w*n);         # 측정 전압
dVdn = w*Vp*cos(w*n);
Gtrue = ag_t*n + bg_t;         # G 참 값
Ctrue = ac_t*n + bc_t;     # C 참 값
dCdn = ac_t;

I = V.*Gtrue + dVdn.*Ctrue + dCdn.*V;   # 측정 전류

inputGraph = figure(1);
subplot(4,1,1);
plot(n,V);
title('Voltage (V)');
subplot(4,1,2);
plot(n,I);
title('Current (A)');
subplot(4,1,3);
plot(n, Gtrue);
title('Conductance (S)');
subplot(4,1,4);
plot(n, Ctrue);
title('Capacitance (F)');

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
            (i+3)*V(i+3) V(i+3) V(i+3)+(i+3)*dVdn(i+3) dVdn(i+3); ];
bk = @(i) [ I(i); I(i+1); I(i+2); I(i+3); ];

Result = inv(Mk(1))*bk(1)
ag_r = Result(1);
bg_r = Result(2);
ac_r = Result(3);
bc_r = Result(4);

tableFig = figure(2);
tableData = { ag_t, ag_r, round((ag_r-ag_t)/ag_t*100000)/1000;
              bg_t, bg_r, round((bg_r-bg_t)/bg_t*100000)/1000;
              ac_t, ac_r, round((ac_r-ac_t)/ac_t*100000)/1000;
              bc_t, bc_r, round((bc_r-bc_t)/bc_t*100000)/1000; };
columnNames = { 'true', 'result', 'error(%)' };
rowNames = { 'ag', 'bg', 'ac', 'bc' };
hTable = uitable('Data', tableData, ...
                 'ColumnName', columnNames, ...
                 'RowName', rowNames);

