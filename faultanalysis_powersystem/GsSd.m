function [Po,Qo,Vo,Ao,EP,EQ,t]=GsSd(Vi,Ai,Pi,Qi,BusType,Ybus) %Gauss-Seidel법
P = Pi; Q= Qi; V = Vi; A = Ai;

numgen = length(find(BusType==2)); % 슬랙을 제외한 발전모선 개수
numload = length(find(BusType==3)); % 부하모선 개수
numtotal = numgen + numload + 1; % 총 모선 수

%---------------기록용 변수-------------
Preal = P; Qreal = Q; count = 0; % 백업, 카운터 초기화
Po=Preal; Qo=Qreal; Vo=V; Ao=A; t=[];EP=[];EQ=[]; % 기록용 변수들
%------------Gauss-Seidal법 시작------------
while(1)
    count = count+1; % 카운터
    P = BusSort(P,BusType,[2 3],4,Pi);
    Q = BusSort(Q,BusType,[3],4,Qi);
    for N=1:numtotal
        [V,A]=voltheta(Ybus,V,A,P+Q*i);
        V = BusSort(V,BusType,[1 2],4,Vi);
        A = BusSort(A,BusType,[1],4,Ai);
    end
    [P Q] = PWCal(Ybus,V,A); % 전력계산
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

function [V,A]=voltheta(Ybus,V,A,S)
   vt=V.*(cos(A)+sin(A)*i);
   vt = (conj(S./vt)-Ybus*vt+(diag(Ybus)).*vt)./(diag(Ybus));
   V = abs(vt);
   A = angle(vt);
end