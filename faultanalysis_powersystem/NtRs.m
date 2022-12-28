function [Po,Qo,Vo,Ao,EP,EQ,t]=NtRs(Vi,Ai,Pi,Qi,BusType,Ybus) %Newton-Raphson법
P = Pi; Q= Qi; V = Vi; A = Ai;

numgen = length(find(BusType==2)); % 슬랙을 제외한 발전모선 개수
numload = length(find(BusType==3)); % 부하모선 개수
numtotal = numgen + numload + 1; % 총 모선 수

%---------------기록용 변수-------------
Preal = P; Qreal = Q; count = 0; % 백업, 카운터 초기화
Po=Preal; Qo=Qreal; Vo=V; Ao=A; t=[];EP=[];EQ=[]; % 기록용 변수들
%------------뉴턴랍손법 시작------------
while(1)
    count = count+1; % 카운터
    %-전압, 위상각으로 전력, 전력 변화 계산-
    [P Q] = PWCal(Ybus,V,A); % 전력계산
    dP = Preal-P;           dQ = Qreal-Q;
    %---------자코비안 행렬 만들고 재구성----------
    % J11에서 슬랙,발전모선 열 제거, 슬랙모선 행 제거
    % J12에서 슬랙모선 열 제거, 슬랙모선 행 제거
    % J11에서 슬랙,발전모선 열 제거, 슬랙,발전모선 행 제거
    % J11에서 슬랙모선 열 제거, 슬랙,발전모선 행 제거
    [J11,J12,J21,J22] = JacobiM(Ybus,V,A);
    J11 = BusSort(J11,BusType,[3],1); J11 = BusSort(J11,BusType,[2 3],2);
    J12 = BusSort(J12,BusType,[2 3],1); J12 = BusSort(J12,BusType,[2 3],2);
    J21 = BusSort(J21,BusType,[3],1); J21 = BusSort(J21,BusType,[3],2);
    J22 = BusSort(J22,BusType,[2 3],1); J22 = BusSort(J22,BusType,[3],2);
    J=[J11 J12;J21 J22];
    %-----------나머지 P,Q벡터의 재구성------------
    dP0 = BusSort(dP,BusType,[2 3],2);% dP0의 슬랙모선 제거
    dQ0 = BusSort(dQ,BusType,[3],2); % dQ0의 슬랙,발전모선 제거
    %---------전압, 위상각의 변화 값 계산----------
    dVdA = J\[dP0;dQ0]; %J\[dP0;dQ0]
    %dVdA : [dV의 부하모선; dA의 발전,부하모선]
    dV0 = dVdA(1:numload); % dV0분리
    dA0 = dVdA(1+numload:size(dVdA)); %dA0분리
    % dV 재구성 : dV의 슬랙,발전모선 부분은 0으로하고 (부하모선)dV0 포함
    dV=BusSort(zeros(numtotal,1),BusType,[3],2,dV0);
    % dA 재구성 : dA의 슬랙모선 부분은 0으로하고
    % (슬랙을 제외한 나머지모선) dA0 포함
    dA=BusSort(zeros(numtotal,1),BusType,[2 3],2,dA0);
    %------------전압, 위상각 값 개선-------------
    V = V+dV;           A = mod(A+dA,2*pi);
    %-------P,Q 기준값(참값)갱신 Preal,Qreal------
    % 슬랙의 P,Q 발전모선의 Q는 참값을 모르기 때문에 갱신.
    Preal=BusSort(Preal,BusType,[1],4,P);
    Qreal=BusSort(Qreal,BusType,[1 2],4,Q);
    %-------------------기록---------------------
    Po =[Po P];  Qo =[Qo Q];
    Vo =[Vo V];  Ao =[Ao A];
    %----------반복계산 끝나는 시점 판단----------
    % 0으로 나눠지는 경우 0대신 realmin으로 계산 함.
    if find(Po(:,count+1)==0) Po(find(Po(:,count+1)==0),count+1)=realmin; end
    if find(Qo(:,count+1)==0) Qo(find(Qo(:,count+1)==0),count+1)=realmin; end
    % P와 Q의 이전값과의 절대오차율중 가장 큰 값을 구해저장
    errP = max(abs((Po(:,count+1) - Po(:,count))./Po(:,count+1)*100));
    errQ = max(abs((Qo(:,count+1) - Qo(:,count))./Qo(:,count+1)*100));
    EP = [EP errP]; EQ = [EQ errQ]; % 오차율 기록
    t = [t count]; % 카운터 기록
    % 0.001%이하의 오차율또는 50회이상 반복에서 종료
    if count>50|(errP<0.001&errQ<0.001) break; end 
end
end
