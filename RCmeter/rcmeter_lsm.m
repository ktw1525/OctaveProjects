#최소 제곱법을 통해서 근사화 시킴

clear all;
close all;
clc;

EpochMax = 10;
solvRate = 0.1;
Cycl = 2;       # 주기 수
Len = 20;     # 데이터 길이
Vp = 311;       # 전압 진폭
w = 2*pi*Cycl/Len;

n = linspace(1,Len,Len); # 샘플번호

%N차 다항식 계수 참 값
a_t = [ 0.01 0.01 ];
b_t = [ 10^-6 10^-6 ];
#미지수 갯수
vars_num = length(a_t) + length(b_t);

V = Vp*sin(w*n);         # 측정 전압
dVdn = w*Vp*cos(w*n);

G_t = polyval(a_t, n);         # G 참 값
C_t = polyval(b_t, n);         # C 참 값
dCdn = polyval(polyder(b_t), n);

I = (G_t + dCdn).*V + C_t.*dVdn;   # 측정 전류

# 입력 데이터
# 1) 전압 V, dVdn
# 2) 전류 I
# 출력 데이터
# 1) 컨덕턴스 Gr
# 2) 캐패시턴스 Cr
# 3) 오차율(참 값: G, C, 측정 값: Gr, Cr)

function ret = Current(idx, v, dvdn, g, c, dcdn, samples)
  ret = ( g(idx) + dcdn(idx) ) * v(idx) + c(idx) * dvdn(idx);
endfunction

function ret = Error(i, v, dvdn, g, c, dcdn, samples)
  ret = 0;
  for m=1:1:samples
    val = Current(m, v, dvdn, g, c, dcdn, samples);
    err = i(m) - val;
    ret += err*err/samples;
  endfor
endfunction

function [g, c, dcdn] = refreshValues(a, b, samples)
  x = 1:1:samples;
  g = polyval(a, x);         # G 참 값
  c = polyval(b, x);         # C 참 값
  dcdn = polyval(polyder(b), x);
endfunction

function ret = dEda_k(p, i, v, dvdn, g, c, dcdn, samples, nth)
  ret = 0;
  pn = nth-p;
  err = i - (g + dcdn).*v + c.*dvdn
  for m=1:1:samples
    val = Current(m, v, dvdn, g, c, dcdn, samples);
    ret += -2*err(m)*(m^pn*v(m))/samples;
  endfor
endfunction

function ret = dEdb_k(p, i, v, dvdn, g, c, dcdn, samples, nth)
  ret = 0;
  pn = nth-p;
  err = i - (g + dcdn).*v + c.*dvdn;
  for m=1:1:samples
    val = Current(m, v, dvdn, g, c, dcdn, samples);
    ret += -2*err(m)*(pn*m^(pn-1)*v(m)+m^pn*dvdn(m))/samples;
  endfor
endfunction

a_r = ones(size(a_t));
b_r = ones(size(b_t));
a_r0 = ones(size(a_t));
b_r0 = ones(size(b_t));

a_r(1) = 1;
a_r(2) = 1;
b_r(1) = 1;
b_r(2) = 1;

figure(1);
errt = [];
for epoch=1:1:EpochMax
  [G_r, C_r, dC_r] = refreshValues(a_r, b_r, Len);
  I_r = (G_r + dC_r).*V + C_r.*dVdn;
  if epoch > 2
    if(errt(length(errt)-1) == 0)
      break;
    end
    if(( abs( errt(length(errt)) - errt(length(errt)-1) ) / errt(length(errt)-1) )*100 < 0.01)
      break;
    end
  end
  nth = length(a_r);
  Err = Error(I, V, dVdn, G_r, C_r, dC_r, Len);

  for p=1:1:nth
    dEda_r_el = dEda_k(p, I, V, dVdn, G_r, C_r, dC_r, Len, nth);
    dEdb_r_el = dEdb_k(p, I, V, dVdn, G_r, C_r, dC_r, Len, nth);

     a_r(p) -= Err/dEda_r_el*solvRate;
     b_r(p) -= Err/dEdb_r_el*solvRate;
  endfor

  errt = [errt sum((I - I_r).*(I - I_r))];
  plot(errt);
  drawnow;
endfor


inputGraph = figure(2);
subplot(4,1,1);
plot(n,V);
title('Voltage (V)');
subplot(4,1,2);
plot(n,I, 'b', n, I_r, 'r:');
title('Current (A)');
subplot(4,1,3);
plot(n, G_t, 'b', n, G_r, 'r:');
title('Conductance (S)');
subplot(4,1,4);
plot(n, C_t, 'b', n, C_r, 'r:');
title('Capacitance (F)');





