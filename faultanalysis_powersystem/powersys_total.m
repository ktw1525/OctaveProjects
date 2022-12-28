function [P,Q,V,A,Ybus]=powersys_total() % 조류계산 메인 함수
clear all
clc
format long
%----------------초기값------------------
fprintf('<<<조류계산>>>\n');
Ofname = input('계통 어드미턴스 및 초기값 설정파일(ex:data\\Sample.xls) : ','s');

%----------설정된 초기값 읽어오기---------
init = xlsread(Ofname,1);
Vi = init(1:size(init,1),4);
Ai = init(1:size(init,1),5)*pi/180;
Pi = init(1:size(init,1),2);
Qi = init(1:size(init,1),3);
BusType = init(1:size(init,1),6)';
Ybus = Ygen(Ofname); % Ybus 생성.
SelectSolution = input('Gauss-Seidal법:1, Newton-Raphson법:2    > ','s');
if SelectSolution == '1' [Po,Qo,Vo,Ao,EP,EQ,t]=GsSd(Vi,Ai,Pi,Qi,BusType,Ybus); %Gauss-Seidal법
else [Po,Qo,Vo,Ao,EP,EQ,t]=NtRs(Vi,Ai,Pi,Qi,BusType,Ybus); %Newton-Raphson법
end
input('< Press ENTER KEY to continue >')
%-------------수렴속도 그래프-------------
Ao=(mod(Ao+pi,2*pi)-pi)*180/pi;
figure(1)
plot(t,[EP;EQ],'-o'); grid on; title('최대 상대오차율 수렴과정');
legend('P','Q'); xlabel('반복회수'); ylabel('상대오차율 최대 값(%)');
figure(2)
subplot(2,2,1); plot([0 t],Po,'-o'); grid on; title('<P값 수렴과정>');
xlabel('반복회수'); ylabel('P');
subplot(2,2,2); plot([0 t],Qo,'-o'); grid on; title('<Q값 수렴과정>');
xlabel('반복회수'); ylabel('Q');
subplot(2,2,3); plot([0 t],Vo,'-o'); grid on; title('<V값 수렴과정>');
xlabel('반복회수'); ylabel('V');
subplot(2,2,4); plot([0 t],Ao,'-o'); grid on; title('<θ값 수렴과정>');
xlabel('반복회수'); ylabel('θ');
%---------------결과 출력----------------
itN = length([0 t]);
fprintf('\n< 초기 설정 값 >')
fprintf('\n%3s %6s %10s %15s %15s %16s\n','BusNum','Type','P','Q','V','θ')
fprintf('%4d %8d %15.4f %15.4f %15.4f %15.4f\n',[[1:length(BusType)].' ...
    BusType.' Pi Qi Vi Ai].')
fprintf('\n< 결과 값 >')
fprintf('\n%3s %6s %10s %15s %15s %16s\n','BusNum','Type','P','Q','V','θ')
fprintf('%4d %8d %15.4f %15.4f %15.4f %15.4f\n',[[1:length(BusType)].' ...
    BusType.' Po(:,itN) Qo(:,itN) Vo(:,itN) Ao(:,itN)].');
ResultF = fopen('data\Result.csv','w+');
fprintf(ResultF,'%s,%s,%s,%s,%s,%s\n','BusNum','Type','P','Q','V','θ');
fprintf(ResultF,'%d,%d,%f,%f,%f,%f\n',[[1:length(BusType)].' ...
    BusType.' Po(:,itN) Qo(:,itN) Vo(:,itN) Ao(:,itN)].');
fclose(ResultF);
fprintf('\n출력 저장 파일 : "data\\Result.csv"\n');
fclose('all');
if input('다시 계산?(Y) : ','s') == 'Y' powersys_total; end
P=Po;Q=Qo;V=Vo;A=Ao;
end

function Ybus = Ygen(filename) %Ybus 메트릭스 생성 function
RXB = xlsread(filename,2);
M = size(RXB,1); % 데이타 줄 수
N = max(max(RXB(:,1:2))); % 모선 총 개수
R=ones(N,N)*realmax; X=ones(N,N)*realmax; % 저항, 리액턴스 매트릭스 빈공간 무한대로 채움
B=zeros(N,N); G=zeros(N,N); % 서셉턴스, 컨덕턴스 메트릭스가 될 변수 선언
for n = 1:M
    if RXB(n,1)~=RXB(n,2) % 버스에 병렬로 연결된 리액턴스 일경우 만
        R(RXB(n,1),RXB(n,2)) = RXB(n,3); % 저항 값 저장
        R(RXB(n,2),RXB(n,1)) = RXB(n,3); % 대칭 행렬꼴로 만듬
        X(RXB(n,1),RXB(n,2)) = RXB(n,4); % 리액턴스 값 저장
        X(RXB(n,2),RXB(n,1)) = RXB(n,4); % 대칭 행렬꼴로 만듬
    end
    B(RXB(n,1),RXB(n,2)) = RXB(n,5); % 서셉턴스 값 저장
    G(RXB(n,1),RXB(n,2)) = RXB(n,6); % 컨덕턴스 값 저장
end
G = G + G.'; % 서셉턴스값 대칭행렬꼴로, 대각성분은 2배
B = B + B.'; % 컨덕턴스값 대칭행렬꼴로, 대각성분은 2배
Y = (R+X*i).^(-1) + (ones(N,1)*sum(B*i+G)/2.*eye(N)); % 어드미턴스 매트릭스 계산
Ybus = zeros(N,N); % Ybus 생성 준비
    for u=1:N % Ybus 행번호
        for j=u:N % Ybus 열번호
            if (u==j) % 대각성분
                for k = 1:N
                    Ybus(u,j) = Ybus(u,j)+Y(u,k);
                end
            else % 비대각성분
                Ybus(j,u) = -Y(u,j); % 대칭 행렬꼴로 만듬
                Ybus(u,j) = -Y(u,j);
            end
        end
    end
    Ybus = round(Ybus*10^5)*10^-5; % Ybus 소숫점아래 5번째 까지 나타냄.
end

function [P Q] = PWCal(Y,Vmag,A) % 전력방정식
V=Vmag.*(cos(A)+sin(A)*i); % V = Vmag∠θ
S=V.*conj(Y*V); % S = V.*conj(I)
P=real(S);
Q=imag(S);
end

function [J11,J12,J21,J22] = JacobiM(Ybus,V,A) %Jacobian Matrix 생성 함수
G = real(Ybus); % 컨덕턴스
B = imag(Ybus); % 서셉턴스
numtotal = length(V); % 모선 총 개수
%J11
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % 대각성분
            J11(n,n) = V(n)*G(n,n);
            for i = 1:numtotal
                Ani = A(n)-A(i); % 상차각 계산
                sumJ = V(i)*(G(n,i)*cos(Ani)+B(n,i)*sin(Ani)); % 시그마 부분
                J11(n,n) = J11(n,n) + sumJ; % 시그마 적산
            end
        else % 비대각성분
            Ani = A(n)-A(m); % 상차각 계산
            J11(n,m) = V(n)*(G(n,m)*cos(Ani)+B(n,m)*sin(Ani));
        end
    end
end
%J12
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % 대각성분
            J12(n,n) = 0;
            for i = 1:numtotal
                if n==i continue; end
                Ani = A(n)-A(i); % 상차각 계산
                sumJ = V(i)*V(n)*(-G(n,i)*sin(Ani)+B(n,i)*cos(Ani)); % 시그마 부분
                J12(n,n) = J12(n,n) + sumJ; % 시그마 적산
            end
        else % 비대각성분
            Ani = A(n)-A(m); % 상차각 계산
            J12(n,m) = V(n)*V(m)*(G(n,m)*sin(Ani)-B(n,m)*cos(Ani));
        end
    end
end
%J21
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % 대각성분
            J21(n,n) = -V(n)*B(n,n);
            for i = 1:numtotal
                Ani = A(n)-A(i); % 상차각 계산
                sumJ = V(i)*(G(n,i)*sin(Ani)-B(n,i)*cos(Ani)); % 시그마 부분
                J21(n,n) = J21(n,n) + sumJ; % 시그마 적산
            end
        else % 비대각성분
            Ani = A(n)-A(m); % 상차각 계산
            J21(n,m) = V(n)*(G(n,m)*sin(Ani)-B(n,m)*cos(Ani));
        end
    end
end
%J22
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % 대각성분
            J22(n,n) = 0;
            for i = 1:numtotal
                if n==i continue; end
                Ani = A(n)-A(i);
                sumJ = V(i)*V(n)*(B(n,i)*sin(Ani)+G(n,i)*cos(Ani)); % 시그마 부분
                J22(n,n) = J22(n,n) + sumJ; % 시그마 적산
            end
        else % 비대각성분
            Ani = A(n)-A(m);
            J22(n,m) = -V(n)*V(m)*(G(n,m)*cos(Ani)+B(n,m)*sin(Ani));
        end
    end
end
end

function [Po,Qo,Vo,Ao,EP,EQ,t]=GsSd(Vi,Ai,Pi,Qi,BusType,Ybus) %Gauss-Seidal법
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
    if count>50|(errP<0.0001&errQ<0.0001) break; end 
    
end
end

function [V,A]=voltheta(Ybus,V,A,S) %Gauss Seidal법에서 전압, 위상각 구하는 함수
   vt=V.*(cos(A)+sin(A)*i);
   vt = (conj(S./vt)-Ybus*vt+(diag(Ybus)).*vt)./(diag(Ybus));
   V = abs(vt);
   A = angle(vt);
end

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

function M = BusSort(M,BusType,K,n,N) % Newton-Raphson법에서 기지량 미지량에 따라 Newton-Raphson식 변형해주는 함수
if nargin<5|isempty(N),N = [];end
% N = []일때,
% M메트릭스에서 BusType이 K인 (n=1 :열, n~=1 :행)을 제거하는 function

% N = 값이 있을 때,
% n = 1 or 2
% M메트릭스에서 BusType이 K인 (n=1 :열, n=2 :행)을
% 순차적으로 N메트릭스의 (n=1:열,n=2:행)로 바꿔줌.
% n = 3 or 4
% M메트릭스에서 BusType이 K인 (n=3 :열, n=그외 :행)을
% N메트릭스의 같은 위치의 (n=3:열,n=else:행)로 바꿔줌.

% K = [x x x x .... x] 형태...
Nbus=[];
for m=1:size(K,2)
    [a,nbus] = find(BusType==K(m));
    Nbus=[Nbus nbus];
end
if size(N)==0
    if n==1 %세로로 제거
        usedbusnum = sort(Nbus); M=M(:,usedbusnum);
    else %가로로 제거
        usedbusnum = sort(Nbus); M=M(usedbusnum,:);
    end
else
    if n==1 %세로로 대입
        usedbusnum = sort(Nbus); M(:,usedbusnum)=N(:,:);
    elseif n==2 %가로로 대입
        usedbusnum = sort(Nbus); M(usedbusnum,:)=N(:,:);
    elseif n==3 %세로로 대입
        usedbusnum = sort(Nbus); M(:,usedbusnum)=N(:,usedbusnum);
    else %가로로 대입
        usedbusnum = sort(Nbus); M(usedbusnum,:)=N(usedbusnum,:);
    end
end
end
