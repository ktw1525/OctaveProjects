function ret = test_3p()
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

  function [g, c, dcdn] = refreshValues(a, b, x)
    g = polyFunc(a, x);
    c = polyFunc(b, x);
    dcdn = diff_polyFunc(b, x);
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

  function ret = Avg(vals)
    ret = 0;
    len = length(vals);
    for k=1:1:len
      ret += vals(k)/len;
    endfor
  endfunction

  Len = 50;
  Period = 24;
  Cycl = Len/Period;
  Vp = 220;

  w = 2*pi/Period;

  printf("SampleLength: %d\r\n", Len);
  printf("Sample Cycles: %d\r\n", Cycl);
  printf("Period: %d\r\n\r\n", Period);

  n_t = 1:1:Len;
  a1_t = [ 0.002*rand()-0.001 0.002*rand()-0.001 ];
  b1_t = [ 0.002*rand()-0.001 0.002*rand()-0.001 ];
  a2_t = [ 0.002*rand()-0.001 0.002*rand()-0.001 ];
  b2_t = [ 0.002*rand()-0.001 0.002*rand()-0.001 ];
  a3_t = [ 0.002*rand()-0.001 0.002*rand()-0.001 ];
  b3_t = [ 0.002*rand()-0.001 0.002*rand()-0.001 ];

  V1_t = Vp*sin(w*n_t);
  V2_t = Vp*sin(w*n_t + 2*pi/3);
  V3_t = Vp*sin(w*n_t - 2*pi/3);
  V1_t = addNoise(V1_t, 0.1);
  V2_t = addNoise(V2_t, 0.1);
  V3_t = addNoise(V3_t, 0.1);

  dV1dn_t = w*Vp*cos(w*n_t);
  dV2dn_t = w*Vp*cos(w*n_t + 2*pi/3);
  dV3dn_t = w*Vp*cos(w*n_t - 2*pi/3);
  dV1dn_t = addNoise(dV1dn_t, 0.1);
  dV2dn_t = addNoise(dV2dn_t, 0.1);
  dV3dn_t = addNoise(dV3dn_t, 0.1);

  [G1_t, C1_t, dC1dn_t] = refreshValues(a1_t, b1_t, n_t);
  [G2_t, C2_t, dC2dn_t] = refreshValues(a2_t, b2_t, n_t);
  [G3_t, C3_t, dC3dn_t] = refreshValues(a3_t, b3_t, n_t);
  I_t = Current(V1_t(n_t), dV1dn_t(n_t), G1_t(n_t), C1_t(n_t), dC1dn_t(n_t)) +...
        Current(V2_t(n_t), dV2dn_t(n_t), G2_t(n_t), C2_t(n_t), dC2dn_t(n_t)) +...
        Current(V3_t(n_t), dV3dn_t(n_t), G3_t(n_t), C3_t(n_t), dC3dn_t(n_t));
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

  n_r = [];
  G1_r = [];
  G2_r = [];
  G3_r = [];
  C1_r = [];
  C2_r = [];
  C3_r = [];
  inputGraph = figure(2);
  n_r0=1:1:Len-Period;
  for i=n_r0
    n_t0 = i:1:i+Period-1;
    printf("idx: %d\r\n", i);
    ret = rcmeter_3pfunc(1:1:Period, V1_t(n_t0), V2_t(n_t0), V3_t(n_t0), dV1dn_t(n_t0), dV2dn_t(n_t0), dV3dn_t(n_t0), I_t(n_t0));

    n_r = [n_r; i+Period/2];
    G1_r = [G1_r; Avg(ret.G1)];
    G2_r = [G2_r; Avg(ret.G2)];
    G3_r = [G3_r; Avg(ret.G3)];
    C1_r = [C1_r; Avg(ret.C1)];
    C2_r = [C2_r; Avg(ret.C2)];
    C3_r = [C3_r; Avg(ret.C3)];

    subplot(4,2,1);
    plot(n_t, V1_t, 'r', n_t, V2_t, 'b',n_t, V3_t, 'g');
    title('Voltage (V)');
    subplot(4,2,2);
    plot(n_t, I_t, 'b');
    title('Current (A)');
    subplot(4,2,3);
    plot(n_t, G1_t, 'bo', n_r, G1_r, 'rx');
    title('Conductance (S)');
    subplot(4,2,5);
    plot(n_t, G2_t, 'bo', n_r, G2_r, 'rx');
    title('Conductance (S)');
    subplot(4,2,7);
    plot(n_t, G3_t, 'bo', n_r, G3_r, 'rx');
    title('Conductance (S)');
    subplot(4,2,4);
    plot(n_t, C1_t, 'bo', n_r, C1_r, 'rx');
    title('Capacitance (F)');
    subplot(4,2,6);
    plot(n_t, C2_t, 'bo', n_r, C2_r, 'rx');
    title('Capacitance (F)');
    subplot(4,2,8);
    plot(n_t, C3_t, 'bo', n_r, C3_r, 'rx');
    title('Capacitance (F)');
    drawnow;
  endfor

  printf("\r\nTrue Values\r\n");
  printf("G1 = %f\r\n",Avg(G1_t));
  printf("C1 = %f\r\n",Avg(G2_t));
  printf("G2 = %f\r\n",Avg(G3_t));
  printf("C2 = %f\r\n",Avg(C1_t));
  printf("G3 = %f\r\n",Avg(C2_t));
  printf("C3 = %f\r\n",Avg(C3_t));

  printf("\r\nEstimated Values\r\n");
  printf("G1 = %f\r\n",Avg(G1_r));
  printf("C1 = %f\r\n",Avg(G2_r));
  printf("G2 = %f\r\n",Avg(G3_r));
  printf("C2 = %f\r\n",Avg(C1_r));
  printf("G3 = %f\r\n",Avg(C2_r));
  printf("C3 = %f\r\n",Avg(C3_r));

endfunction
