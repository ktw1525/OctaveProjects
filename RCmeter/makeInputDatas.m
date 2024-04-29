function ret=makeInputDatas(Len, Period)
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

  Cycl = Len/Period;
  Vp = 220;
  w = 2*pi/Period;

  n_t = 1:1:Len;
  a1_t = 0.0002*rand();#[ 0.002*rand() 0.002*rand() ];
  b1_t = 0.0002*rand();#[ 0.002*rand() 0.002*rand() ];
  a2_t = 0.0002*rand();#[ 0.002*rand() 0.002*rand() ];
  b2_t = 0.0002*rand();#[ 0.002*rand() 0.002*rand() ];
  a3_t = 0.0002*rand();#[ 0.002*rand() 0.002*rand() ];
  b3_t = 0.0002*rand();#[ 0.002*rand() 0.002*rand() ];

  V1_t = Vp*sin(w*n_t);
  V2_t = Vp*sin(w*n_t + 2*pi/3);
  V3_t = Vp*sin(w*n_t - 2*pi/3);
  V1_t = addNoise(V1_t, 0.1);
  V2_t = addNoise(V2_t, 0.1);
  V3_t = addNoise(V3_t, 0.1);

  dV1dn_t = [0, diff(V1_t)];
  dV2dn_t = [0, diff(V2_t)];
  dV3dn_t = [0, diff(V3_t)];

  [G1_t, C1_t, dC1dn_t] = refreshValues(a1_t, b1_t, n_t);
  [G2_t, C2_t, dC2dn_t] = refreshValues(a2_t, b2_t, n_t);
  [G3_t, C3_t, dC3dn_t] = refreshValues(a3_t, b3_t, n_t);
  I_t = Current(V1_t(n_t), dV1dn_t(n_t), G1_t(n_t), C1_t(n_t), dC1dn_t(n_t)) +...
        Current(V2_t(n_t), dV2dn_t(n_t), G2_t(n_t), C2_t(n_t), dC2dn_t(n_t)) +...
        Current(V3_t(n_t), dV3dn_t(n_t), G3_t(n_t), C3_t(n_t), dC3dn_t(n_t));
  I_t = addNoise(I_t, 0.00);

  ret = struct(
    "n", n_t,
    "V1", V1_t,
    "V2", V2_t,
    "V3", V3_t,
    "dV1dn", dV1dn_t,
    "dV2dn", dV2dn_t,
    "dV3dn", dV3dn_t,
    "I", I_t,
    "G1", G1_t,
    "G2", G2_t,
    "G3", G3_t,
    "C1", C1_t,
    "C2", C2_t,
    "C3", C3_t
  );
endfunction

