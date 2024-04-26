function ret = rcmeter_3p()
  function ret = addNoise(sig, rate)
    len = length(sig);
    ret = sig;
    rms = 0;
    for i=1:1:len
      rms += sig(i)*sig(i)/len;
    endfor
    rms = sqrt(rms);
    for i=1:1:len
      ret(i) += (2*rand() - 1)*rms*rate;
    endfor
  endfunction

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

  EpochMax = 1000;
  EndErr = 0.001;
  solvRate = 0.1;
  beta = 0.998;
  Cycl = 0.01;
  Len = 12;
  freq1 = 11;
  freq2 = 13;
  SamplingRate = Len/Cycl; # Samples per 1 cycle.
  Vp = 220;
  w = 2*pi*Cycl/Len;

  printf("SampleLength: %d\r\n", Len);
  printf("SamplingRate: %d\r\n\r\n", SamplingRate);

  n_t = 1:1:Len;
  a1_t = [ 0.0002 0.002 ];
  b1_t = [ 0.03 -0.002 ];
  a2_t = [ 0.0001 0.001 ];
  b2_t = [ 0.005 -0.001 ];
  a3_t = [ 0.0003 0.004 ];
  b3_t = [ 0.04 -0.002 ];

  V1_t = Vp*sin(w*n_t) + Vp*0.01*sin(freq1*w*n_t);
  V2_t = Vp*sin(w*n_t + 2*pi/3) + Vp*0.003*sin(freq2*w*n_t);
  V3_t = Vp*sin(w*n_t - 2*pi/3);
V1_t = addNoise(V1_t, 0.001);
V2_t = addNoise(V2_t, 0.001);
V3_t = addNoise(V3_t, 0.001);

  dV1dn_t = w*Vp*cos(w*n_t) + freq1*w*Vp*0.01*cos(freq1*w*n_t);
  dV2dn_t = w*Vp*cos(w*n_t + 2*pi/3) + freq2*w*Vp*0.003*cos(freq2*w*n_t);
  dV3dn_t = w*Vp*cos(w*n_t - 2*pi/3);
dV1dn_t = addNoise(dV1dn_t, 0.002);
dV2dn_t = addNoise(dV2dn_t, 0.002);
dV3dn_t = addNoise(dV3dn_t, 0.002);

  [G1_t, C1_t, dC1dn_t] = refreshValues(a1_t, b1_t, n_t);
  [G2_t, C2_t, dC2dn_t] = refreshValues(a2_t, b2_t, n_t);
  [G3_t, C3_t, dC3dn_t] = refreshValues(a3_t, b3_t, n_t);
  I_t = Current(V1_t, dV1dn_t, G1_t, C1_t, dC1dn_t) + ...
        Current(V2_t, dV2dn_t, G2_t, C2_t, dC2dn_t) + ...
        Current(V3_t, dV3dn_t, G3_t, C3_t, dC3dn_t);
  I_t = addNoise(I_t, 0.01);

  inputGraph = figure(1);
  subplot(4,2,1);
  plot(n_t, V1_t, 'r', n_t, V2_t, 'b',n_t, V3_t, 'g');
  title('Voltage (V)');
  subplot(4,2,2);
  plot(n_t, I_t, 'b');
  title('Current (A)');
  subplot(4,2,3);
  plot(n_t, G1_t, 'b');
  title('Conductance (S)');
  subplot(4,2,5);
  plot(n_t, G2_t, 'b');
  title('Conductance (S)');
  subplot(4,2,7);
  plot(n_t, G3_t, 'b');
  title('Conductance (S)');
  subplot(4,2,4);
  plot(n_t, C1_t, 'b');
  title('Capacitance (F)');
  subplot(4,2,6);
  plot(n_t, C2_t, 'b');
  title('Capacitance (F)');
  subplot(4,2,8);
  plot(n_t, C3_t, 'b');
  title('Capacitance (F)');



  a1_r = [0,0];
  b1_r = [0,0];
  a2_r = [0,0];
  b2_r = [0,0];
  a3_r = [0,0];
  b3_r = [0,0];

  a1th = length(a1_r);
  a2th = length(a2_r);
  a3th = length(a3_r);
  b1th = length(b1_r);
  b2th = length(b2_r);
  b3th = length(b3_r);
  vars_num =  a1th + b1th + a2th + b2th + a3th + b3th;

  figure(3);
  errt = [];
  Irms = ErrorSquare(I_t, zeros(size(I_t)), n_t);

  Err0 = 0;
  printf("idx errDiffRate\r\n");
  for epoch=1:1:EpochMax
    [G1_r, C1_r, dC1dn_r] = refreshValues(a1_r, b1_r, n_t);
    [G2_r, C2_r, dC2dn_r] = refreshValues(a2_r, b2_r, n_t);
    [G3_r, C3_r, dC3dn_r] = refreshValues(a3_r, b3_r, n_t);

    I_r = Current(V1_t, dV1dn_t, G1_r, C1_r, dC1dn_r)+...
          Current(V2_t, dV2dn_t, G2_r, C2_r, dC2dn_r)+...
          Current(V3_t, dV3dn_t, G3_r, C3_r, dC3dn_r);
    Err = ErrorSquare(I_t, I_r, n_t);
    errt = [errt Err];
    plot(errt, 'rx-');
    drawnow;
    errDiffRate = (Err0 - Err) / Err * 100;
    printf("%d) %.3f\r\n",epoch, errDiffRate );

    if ( Err == 0 ) break; end
    if ( epoch > 1 && errDiffRate < 0.03 ) break; end

    if epoch > 2
      if(errt(epoch) == 0)
        printf("Finish 1\r\n");
        break;
      end
      if( abs( Err / Irms ) < EndErr )
        printf("Finish 2\r\n");
        break;
      end
    end
    solvRate*=beta;

    # dI = dIda * da + dIdb * db
    # I_t0 - I_r0 = dIda * (a_r - a_r0) + dIdb * (b_r - b_r0)
    # B = [I_t0 - I_r0];
    # M = [dIda, dIdb];
    # x = [a_r - a_r0];
    # solv: B = M * x
    # a_r <- a_r + x;

    rows = vars_num;
    batchSize = floor(Len/rows);
    M = [];
    B = [];
    B = [];
    for row= 1:1:rows
      ROW=[];
      n_r=((row-1)*batchSize)+1:1:(row*batchSize);
      for p=1:1:a1th
        ROW = [ROW, dIda_k(p, n_r, V1_t, dV1dn_t)];
      endfor

      for p=1:1:a2th
        ROW = [ROW, dIda_k(p, n_r, V2_t, dV2dn_t)];
      endfor

      for p=1:1:a3th
        ROW = [ROW, dIda_k(p, n_r, V3_t, dV3dn_t)];
      endfor

      for p=1:1:b1th
        ROW = [ROW, dIdb_k(p, n_r, V1_t, dV1dn_t)];
      endfor

      for p=1:1:b2th
        ROW = [ROW, dIdb_k(p, n_r, V2_t, dV2dn_t)];
      endfor

      for p=1:1:b3th
        ROW = [ROW, dIdb_k(p, n_r, V3_t, dV3dn_t)];
      endfor

      I_t0 = Current(V1_t(n_r), dV1dn_t(n_r), G1_t(n_r), C1_t(n_r), dC1dn_t(n_r)) +...
             Current(V2_t(n_r), dV2dn_t(n_r), G2_t(n_r), C2_t(n_r), dC2dn_t(n_r)) +...
             Current(V3_t(n_r), dV3dn_t(n_r), G3_t(n_r), C3_t(n_r), dC3dn_t(n_r));
      I_r0 = Current(V1_t(n_r), dV1dn_t(n_r), G1_r(n_r), C1_r(n_r), dC1dn_r(n_r)) +...
             Current(V2_t(n_r), dV2dn_t(n_r), G2_r(n_r), C2_r(n_r), dC2dn_r(n_r)) +...
             Current(V3_t(n_r), dV3dn_t(n_r), G3_r(n_r), C3_r(n_r), dC3dn_r(n_r));

      M = [M; ROW];
      B = [B; Avg(I_t0 - I_r0, batchSize)];
    endfor

    x_r = inv(M)*B;

    cursor=0;
    for p=1:1:a1th
      a1_r(p) += x_r(p+cursor)*solvRate;
    endfor
    cursor+=a1th;
    for p=1:1:a2th
      a2_r(p) += x_r(p+cursor)*solvRate;
    endfor
    cursor+=a2th;
    for p=1:1:a3th
      a3_r(p) += x_r(p+cursor)*solvRate;
    endfor
    cursor+=a3th;
    for p=1:1:b1th
      b1_r(p) += x_r(p+cursor)*solvRate;
    endfor
    cursor+=b1th;
    for p=1:1:b2th
      b2_r(p) += x_r(p+cursor)*solvRate;
    endfor
    cursor+=b2th;
    for p=1:1:b3th
      b3_r(p) += x_r(p+cursor)*solvRate;
    endfor
    Err0 = Err;
  endfor

  inputGraph = figure(2);
  subplot(4,2,1);
  plot(n_t, V1_t, 'r', n_t, V2_t, 'b',n_t, V3_t, 'g');
  title('Voltage (V)');
  subplot(4,2,2);
  plot(n_t, I_t, 'bo', n_t, I_r, 'rx');
  title('Current (A)');
  subplot(4,2,3);
  plot(n_t, G1_t, 'bo', n_t, G1_r, 'rx');
  title('Conductance (S)');
  subplot(4,2,5);
  plot(n_t, G2_t, 'bo', n_t, G2_r, 'rx');
  title('Conductance (S)');
  subplot(4,2,7);
  plot(n_t, G3_t, 'bo', n_t, G3_r, 'rx');
  title('Conductance (S)');
  subplot(4,2,4);
  plot(n_t, C1_t, 'bo', n_t, C1_r, 'rx');
  title('Capacitance (F)');
  subplot(4,2,6);
  plot(n_t, C2_t, 'bo', n_t, C2_r, 'rx');
  title('Capacitance (F)');
  subplot(4,2,8);
  plot(n_t, C3_t, 'bo', n_t, C3_r, 'rx');
  title('Capacitance (F)');

  printf("\r\nTrue Values\r\n");
  printf("G1 = %s\r\n",polyout(flip(a1_t), 'n'));
  printf("C1 = %s\r\n",polyout(flip(b1_t), 'n'));
  printf("G2 = %s\r\n",polyout(flip(a2_t), 'n'));
  printf("C2 = %s\r\n",polyout(flip(b2_t), 'n'));
  printf("G3 = %s\r\n",polyout(flip(a3_t), 'n'));
  printf("C3 = %s\r\n",polyout(flip(b3_t), 'n'));

  printf("\r\nEstimated Values\r\n");
  printf("G1 = %s\r\n",polyout(flip(a1_r), 'n'));
  printf("C1 = %s\r\n",polyout(flip(b1_r), 'n'));
  printf("G2 = %s\r\n",polyout(flip(a2_r), 'n'));
  printf("C2 = %s\r\n",polyout(flip(b2_r), 'n'));
  printf("G3 = %s\r\n",polyout(flip(a3_r), 'n'));
  printf("C3 = %s\r\n",polyout(flip(b3_r), 'n'));
endfunction
