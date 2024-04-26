function ret = rcmeter_lsm()
  EpochMax = 20;
  solvRate = 0.01;
  Cycl = 1;
  Len = 20;
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

  figure(1);
  errt = [];
  Irms = ErrorSquare(I_t, zeros(size(I_t)), n_t);

  for epoch=1:1:EpochMax
    [G_r, C_r, dCdn_r] = refreshValues(a_r, b_r, n_t);
    I_r = Current(V_t, dVdn_t, G_r, C_r, dCdn_r);
    Err = ErrorSquare(I_t, I_r, n_t);
    errt = [errt Err];
    plot(errt, 'rx-');
    drawnow;
    printf("%d) %.3f\r\n",epoch, Err);

    if ( Err == 0 ) break; end
    if epoch > 2
      if(errt(epoch) == 0)
        printf("Finish 1\r\n");
        break;
      end
      if( abs( Err / Irms ) < 0.001)
        printf("Finish 2\r\n");
        break;
      end
    end

    # dI = dIda * da + dIdb * db
    # I_t0 - I_r0 = dIda * (a_r - a_r0) + dIdb * (b_r - b_r0)
    # B = [I_t0 - I_r0];
    # M = [dIda, dIdb];
    # x = [a_r - a_r0];
    # solv: B = M * x
    # a_r <- a_r + x;

    rows = ath+bth;
    batchSize = rows ; #floor(Len/rows);
    M = [];
    B = [];
    for row= 1:1:rows
      ROW=[];
      n_r=((row-1)*batchSize)+1:1:(row*batchSize);
      for p=1:1:ath
        ROW = [ROW, dIda_k(p, n_r, V_t, dVdn_t)];
      endfor
      for p=1:1:bth
        ROW = [ROW, dIdb_k(p, n_r, V_t, dVdn_t)];
      endfor
      I_t0 = Current(V_t(n_r), dVdn_t(n_r), G_t(n_r), C_t(n_r), dCdn_t(n_r));
      I_r0 = Current(V_t(n_r), dVdn_t(n_r), G_r(n_r), C_r(n_r), dCdn_r(n_r));

      M = [M; ROW];
      B = [B; Avg(I_t0 - I_r0, batchSize)];
    endfor

    x_r = inv(M)*B;

    for p=1:1:ath
      a_r(p) += x_r(p)*solvRate;
    endfor
    for p=1:1:bth
      b_r(p) += x_r(ath+p)*solvRate;
    endfor
  endfor

  inputGraph = figure(2);
  subplot(4,1,1);
  plot(n_t, V_t);
  title('Voltage (V)');
  subplot(4,1,2);
  plot(n_t, I_t, 'bo', n_t, I_r, 'rx');
  title('Current (A)');
  subplot(4,1,3);
  plot(n_t, G_t, 'bo', n_t, G_r, 'rx');
  title('Conductance (S)');
  subplot(4,1,4);
  plot(n_t, C_t, 'bo', n_t, C_r, 'rx');
  title('Capacitance (F)');

  printf("G = %s\r\n",polyout(flip(a_r), 'n'));
  printf("C = %s\r\n",polyout(flip(b_r), 'n'));
endfunction
