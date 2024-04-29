function ret = rcmeter_3pfunc(n_t, V1_t, V2_t, V3_t, dV1dn_t, dV2dn_t, dV3dn_t, I_t)
  Len = 12;
  EpochMax = 1000;
  EndErr = 0.001;
  solvRate = 0.01;
  beta = 0.998;

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

  #figure(3);
  errt = [];
  Irms = ErrorSquare(I_t, zeros(size(I_t)), n_t);

  Err0 = 0;
  #printf("idx errDiffRate\r\n");
  for epoch=1:1:EpochMax
    [G1_r, C1_r, dC1dn_r] = refreshValues(a1_r, b1_r, n_t);
    [G2_r, C2_r, dC2dn_r] = refreshValues(a2_r, b2_r, n_t);
    [G3_r, C3_r, dC3dn_r] = refreshValues(a3_r, b3_r, n_t);

    I_r = Current(V1_t, dV1dn_t, G1_r, C1_r, dC1dn_r)+...
          Current(V2_t, dV2dn_t, G2_r, C2_r, dC2dn_r)+...
          Current(V3_t, dV3dn_t, G3_r, C3_r, dC3dn_r);
    Err = ErrorSquare(I_t, I_r, n_t);
    errt = [errt Err];
    #plot(errt, 'rx-');
    #drawnow;
    errDiffRate = (Err0 - Err) / Err * 100;
    #printf("%d) %.3f\r\n",epoch, errDiffRate );

    if ( Err == 0 ) break; end
    if ( epoch > 1 && errDiffRate < 0.03 ) break; end

    if epoch > 2
      if(errt(epoch) == 0)
        #printf("Finish 1\r\n");
        break;
      end
      if( abs( Err / Irms ) < EndErr )
        #printf("Finish 2\r\n");
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

      I_r0 = Current(V1_t(n_r), dV1dn_t(n_r), G1_r(n_r), C1_r(n_r), dC1dn_r(n_r)) +...
             Current(V2_t(n_r), dV2dn_t(n_r), G2_r(n_r), C2_r(n_r), dC2dn_r(n_r)) +...
             Current(V3_t(n_r), dV3dn_t(n_r), G3_r(n_r), C3_r(n_r), dC3dn_r(n_r));
      M = [M; ROW];
      B = [B; Avg(I_t(n_r) - I_r0, batchSize)];
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

  ret = struct(
          "G1", G1_r,
          "G2", G2_r,
          "G3", G3_r,
          "C1", C1_r,
          "C2", C2_r,
          "C3", C3_r,
          "a1", a1_r,
          "a2", a2_r,
          "a3", a3_r,
          "b1", b1_r,
          "b2", b2_r,
          "b3", b3_r,
          "I", I_r
        );
endfunction
