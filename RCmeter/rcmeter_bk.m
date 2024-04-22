function ret = rcmeter_bk()
  EpochMax = 20;
  solvRate = 0.01;
  Cycl = 1;
  Len = 100;
  Vp = 220;
  w = 2*pi*Cycl/Len;

  n_t = 1:1:Len;

  a_t = [ 0.0002 0.002 ];
  b_t = [ 0.3 -0.002 ];

  ath = length(a_t);
  bth = length(b_t);
  vars_num = ath + bth;

  V_t = Vp*sin(w*n_t);
  dVdn_t = w*Vp*cos(w*n_t);

  function ret = polyFunc(a, x)
    ret = 0;
    for m=1:1:length(x)
      for p=1:1:length(a)
        ret += a(p).*x.^(p-1);
      endfor
    endfor
  endfunction

  function ret = diff_polyFunc(a, x)
    ret = 0;
    for m=1:1:length(x)
      for p=1:1:length(a)
        ret += (p-1)*a(p).*x.^(p-2);
      endfor
    endfor
  endfunction

  function ret = Current(v, dvdn, g, c, dcdn)
    ret = ( g + dcdn ) .* v + c .* dvdn;
  endfunction

  function ret = ErrorSquare(it, ir, N)
    ret = 0;
    for m=N
      err = ir(m) - it(m);
      ret += err*err/length(N);
    endfor
    ret = sqrt(ret);
  endfunction

  function [g, c, dcdn] = refreshValues(a, b, x)
    g = polyFunc(a, x);
    c = polyFunc(b, x);
    dcdn = diff_polyFunc(b, x);
  endfunction

  function ret = Avg(val, len)
    ret = 0;
    for k=1:1:len
      ret += val(k)/len;
    endfor
  endfunction

  [G_t, C_t, dCdn_t] = refreshValues(a_t, b_t, n_t);
  I_t = Current(V_t, dVdn_t, G_t, C_t, dCdn_t);

  inputGraph = figure(2);
  subplot(4,1,1);
  plot(n_t, V_t);
  title('Voltage (V)');
  subplot(4,1,2);
  plot(n_t, I_t, 'b');
  title('Current (A)');
  subplot(4,1,3);
  plot(n_t, G_t, 'b');
  title('Conductance (S)');
  subplot(4,1,4);
  plot(n_t, C_t, 'b');
  title('Capacitance (F)');

  function ret = dIda_k(p, N, v, dvdn)
    pn = p -1;
    ret = 0;
    for m=N
      ret += m^pn*v(m);
    endfor
    ret /= length(N);
  endfunction

  function ret = dIdb_k(p, N, v, dvdn)
    pn = p -1;
    ret = 0;
    for m=N
      ret += pn*m^(pn-1)*v(m) + m^pn*dvdn(m);
    endfor
    ret /= length(N);
  endfunction

  a_r = zeros(10,1);
  b_r = zeros(10,1);
   
  FTT = fft_with_nth(G_t);
  As = FTT(1,:);
  Bs = FTT(2,:);
  Sm = revsfft(As, Bs, Len);
  
  figure(3);
  subplot(3,1,1);
  plot(As);
  subplot(3,1,2);
  plot(Bs);
  subplot(3,1,3);
  plot(n_t, G_t, 'bo', n_t, Sm, 'rx');
endfunction
