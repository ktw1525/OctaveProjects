function ret = rcmeter_lsm()
  
  #최소 제곱법을 통해서 근사화 시킴
  EpochMax = 10;
  solvRate = 0.01;
  Cycl = 3;       # 주기 수
  Len = 200;     # 데이터 길이
  Vp = 220;       # 전압 진폭
  w = 2*pi*Cycl/Len;

  n_t = 1:1:Len; # 샘플번호

  %N차 다항식 계수 참 값
  a_t = [ 0.01 0.02 ];
  b_t = [ 10^-6 20^-6 ];
  #미지수 갯수
  ath = length(a_t);
  bth = length(b_t);
  vars_num = ath + bth;

  V_t = Vp*sin(w*n_t);         # 측정 전압
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
      ret += err*err/samples;
    endfor
  endfunction

  function [g, c, dcdn] = refreshValues(a, b, x)
    g = polyFunc(a, x);         
    c = polyFunc(b, x);         
    dcdn = diff_polyFunc(b, x);
  endfunction

  [G_t, C_t, dCdn_t] = refreshValues(a_t, b_t, n_t);
  I_t = Current(V_t, dVdn_t, G_t, C_t, dCdn_t); #측정전류

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

  # 입력 데이터
  # 1) 전압 V, dVdn
  # 2) 전류 I
  # 출력 데이터
  # 1) 컨덕턴스 Gr
  # 2) 캐패시턴스 Cr
  # 3) 오차율(참 값: G, C, 측정 값: Gr, Cr)
  
  function ret = dIda_k(p, i, v, dvdn, g, c, dcdn)
    pn = p -1;
    ret = m^pn*v(m);
  endfunction

  function ret = dIdb_k(p, i, v, dvdn, g, c, dcdn)
    pn = p -1;
    ret = pn*m^(pn-1)*v(m) + m^pn*dvdn(m);
  endfunction

  a_r = ones(size(a_t));
  b_r = ones(size(b_t));
  #a_r = a_t;
  #b_r = b_t;

  figure(1);
  errt = [];
  Irms = ErrorSquare(I_t, zeros(size(I_t)), n_t);  
  %샘플 개수 미지수 만큼 나눠서 에러를 계산하고 매트리스를 푼다!
  
  for epoch=1:1:EpochMax
    [G_r, C_r, dCdn_r] = refreshValues(a_r, b_r, n_t);
    I_r = Current(V_t, dVdn_t, G_r, C_r, dCdn_r); #추정전류
    Err = ErrorSquare(I_t, I_r, n_t);
    errt = [errt Err];
    plot(errt, 'rx-');
    drawnow;
    printf("%d) %.3f\r\n",epoch, Err); 
    
    if ( Err == 0 ) break; end
    if epoch > 2
      if(errt(epoch) == 0)
        printf("Finish 1");
        break;
      end
      if( abs( Err / Irms ) < 0.03)
        printf("Finish 2");
        break;
      end
    end
    
    # dI = dIda * da + dIdb * db
        
 
    for p=1:1:ath

    
    endfor
  endfor
  
  
  
  inputGraph = figure(2);
  subplot(4,1,1);
  plot(n_t, V_t);
  title('Voltage (V)');
  subplot(4,1,2);
  plot(n_t, I_t, 'b:', n_t, I_r, 'rx');
  title('Current (A)');
  subplot(4,1,3);
  plot(n_t, G_t, 'b:', n_t, G_r, 'rx');
  title('Conductance (S)');
  subplot(4,1,4);
  plot(n_t, C_t, 'b:', n_t, C_r, 'rx');
  title('Capacitance (F)');




endfunction