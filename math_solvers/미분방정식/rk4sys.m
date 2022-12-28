function [tp,yp] = rk4sys(dydt,tspan,y0,h,varargin)
% 4차 Runge-Kutta법을 사용하여 상미분방정식을 푼다.
% 미분방정식dydt를 독립변수tspan에 대하여 적분된 종속변수yp를
% 구한다. t0에서의 y0는 초기값이고 h는 t의 스탭사이즈다.
if nargin<4,error('at least 4 input arguments required'),end
if any(diff(tspan)<=0), error('tspan not ascending order'),end
n = length(tspan);
ti = tspan(1); tf=tspan(n);
if n==2
    t = (ti:h:tf)'; n = length(t);    %%%%%%%%%%%%%%%%%%%%%%%%
    if t(n)<tf                        % tspan이 끝점만 주워진 %
        t(n+1)=tf;                    % 경우, 모든 데이터가   %
        n = n+1;                      % 주워진 경우를 고려.   %
    end                               %%%%%%%%%%%%%%%%%%%%%%%%
else
    t = tspan;
end
tt = ti; y(1,:) = y0;
np = 1; tp(np) = tt; yp(np,:) = y(1,:);
i = 1;
while(1)                             % 4차 Runge-Kutta법 적용
    tend = t(np+1);
    hh = t(np+1) - t(np);
    if hh>h,hh = h; end
    while(1)
        if tt+hh>tend,hh=tend-tt;end
        k1 = dydt(tt,y(i,:),varargin{:})';
        ymid = y(i,:) + k1.*hh./2;
        k2 = dydt(tt+hh/2,ymid,varargin{:})';
        ymid = y(i,:) + k2*hh/2;
        k3 = dydt(tt+hh/2,ymid,varargin{:})';
        yend = y(i,:) + k3*hh;
        k4 = dydt(tt+hh,yend,varargin{:})';
        phi = (k1+2*(k2+k3)+k4)/6;
        y(i+1,:) = y(i,:)+phi*hh;
        tt=tt+hh;
        i=i+1;
        if tt>=tend,break,end
    end
    np = np+1; tp(np) = tt; yp(np,:) = y(i,:);
    if tt>=tf,break,end
end
plot(tp,yp); grid %그래프 그리기
end
        