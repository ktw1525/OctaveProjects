function ret=rcmeter_vct(n_t, period, V1_t, V2_t, V3_t, dV1dn_t, dV2dn_t, dV3dn_t, I_t)
  ret = 0;
  function ret=nfft(sig, period)
    len = length(sig);
    if(len < 10)
      printf("적어도 10개의 샘플 이상이 있어야 합니다.\r\n");
      return;
    end
    ret = [];
    endHdn = 11;
    if(endHdn > floor(period/5))
      endHdn = floor(period/5);
    endif
    for harmonic=1:1:endHdn
      A= 0;
      B= 0;
      prd = period/harmonic; # harmonic의 주기
      CyclesNum= floor(len/prd); # 주어진 데이터에 몇개의 harmonic이 있는지
      for p=1:1:prd*CyclesNum
        A+= sig(p)*sin(2*pi/prd*p)/prd/CyclesNum*2;
        B+= sig(p)*cos(2*pi/prd*p)/prd/CyclesNum*2;
      endfor
      ret = [ ret; [A,B] ];
    endfor
  endfunction

  function ret=vct_mag(x, y)
    ret = sqrt(x.*x + y.*y);
  endfunction

  function arr=pickMaxHD(vcts, number)
    arr = [];
    for n=1:1:number
      [maxnumber, index] = max(vct_mag(vcts(:,1),vcts(:,2)));
      vcts(index,1) = 0;
      vcts(index,2) = 0;
      arr = [arr; index];
    endfor
  endfunction

  function ret=picker(hds,number)
    linear = hds(:);
    unq = unique(linear);
    ret = unq(1:1:number);
  endfunction

  function ret = vectorize3p(period,V1_t,V2_t,V3_t,I_t)
    V1_vct = nfft(V1_t, period);
    V2_vct = nfft(V2_t, period);
    V3_vct = nfft(V3_t, period);
    I_vct = nfft(I_t, period);
    dV1_vct = nfft(dV1dn_t, period);
    dV2_vct = nfft(dV2dn_t, period);
    dV3_vct = nfft(dV3dn_t, period);

    hds = picker([pickMaxHD(V1_vct, 3), pickMaxHD(V2_vct, 3), pickMaxHD(V3_vct, 3)], 3);
    V1_vct = V1_vct(hds,:);
    V2_vct = V2_vct(hds,:);
    V3_vct = V3_vct(hds,:);
    I_vct = I_vct(hds,:);
    dV1_vct = dV1_vct(hds,:);
    dV2_vct = dV2_vct(hds,:);
    dV3_vct = dV3_vct(hds,:);

    #V1_vct,V2_vct,V3_vct,dV1_vct,dV2_vct,dV3_vct,I_vct
    ret = struct(
      "V1", V1_vct,
      "V2", V2_vct,
      "V3", V3_vct,
      "I", I_vct,
      "dV1", dV1_vct,
      "dV2", dV2_vct,
      "dV3", dV3_vct
    );
  endfunction

  inputs_vct = vectorize3p(period,V1_t,V2_t,V3_t,I_t);
  Y = [ inputs_vct.I(1,1);
        inputs_vct.I(2,1);
        inputs_vct.I(3,1);
        inputs_vct.I(1,2);
        inputs_vct.I(2,2);
        inputs_vct.I(3,2) ];
  M = [ inputs_vct.V1(1,1), inputs_vct.dV1(1,1), inputs_vct.V2(1,1), inputs_vct.dV2(1,1), inputs_vct.V3(1,1), inputs_vct.dV3(1,1);
        inputs_vct.V1(2,1), inputs_vct.dV1(2,1), inputs_vct.V2(2,1), inputs_vct.dV2(2,1), inputs_vct.V3(2,1), inputs_vct.dV3(2,1);
        inputs_vct.V1(3,1), inputs_vct.dV1(3,1), inputs_vct.V2(3,1), inputs_vct.dV2(3,1), inputs_vct.V3(3,1), inputs_vct.dV3(3,1);
        inputs_vct.V1(1,2), inputs_vct.dV1(1,2), inputs_vct.V2(1,2), inputs_vct.dV2(1,2), inputs_vct.V3(1,2), inputs_vct.dV3(1,2);
        inputs_vct.V1(2,2), inputs_vct.dV1(2,2), inputs_vct.V2(2,2), inputs_vct.dV2(2,2), inputs_vct.V3(2,2), inputs_vct.dV3(2,2);
        inputs_vct.V1(3,2), inputs_vct.dV1(3,2), inputs_vct.V2(3,2), inputs_vct.dV2(3,2), inputs_vct.V3(3,2), inputs_vct.dV3(3,2) ];
  X=inv(M)*Y;
  ret=struct( "G1", X(1),
              "C1", X(2),
              "G2", X(3),
              "C2", X(4),
              "G3", X(5),
              "C3", X(6) );
end
