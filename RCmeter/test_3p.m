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
  
  Cycl = 3;
  Len = 24;
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
  V1_t = addNoise(V1_t, 0.01);
  V2_t = addNoise(V2_t, 0.01);
  V3_t = addNoise(V3_t, 0.01);

  dV1dn_t = w*Vp*cos(w*n_t) + freq1*w*Vp*0.01*cos(freq1*w*n_t);
  dV2dn_t = w*Vp*cos(w*n_t + 2*pi/3) + freq2*w*Vp*0.003*cos(freq2*w*n_t);
  dV3dn_t = w*Vp*cos(w*n_t - 2*pi/3);
  dV1dn_t = addNoise(dV1dn_t, 0.01);
  dV2dn_t = addNoise(dV2dn_t, 0.01);
  dV3dn_t = addNoise(dV3dn_t, 0.01);

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

  ret = rcmeter_3pfunc(n_t, V1_t, V2_t, V3_t, dV1dn_t, dV2dn_t, dV3dn_t, I_t);

  G1_r = ret.G1;
  G2_r = ret.G2;
  G3_r = ret.G3;
  C1_r = ret.C1;
  C2_r = ret.C2;
  C3_r = ret.C3;
  a1_r = ret.a1;
  a2_r = ret.a2;
  a3_r = ret.a3;
  b1_r = ret.b1;
  b2_r = ret.b2;
  b3_r = ret.b3;
  I_r = ret.I;
  
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
