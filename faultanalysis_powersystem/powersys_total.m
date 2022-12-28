function [P,Q,V,A,Ybus]=powersys_total() % ������� ���� �Լ�
clear all
clc
format long
%----------------�ʱⰪ------------------
fprintf('<<<�������>>>\n');
Ofname = input('���� �����Ͻ� �� �ʱⰪ ��������(ex:data\\Sample.xls) : ','s');

%----------������ �ʱⰪ �о����---------
init = xlsread(Ofname,1);
Vi = init(1:size(init,1),4);
Ai = init(1:size(init,1),5)*pi/180;
Pi = init(1:size(init,1),2);
Qi = init(1:size(init,1),3);
BusType = init(1:size(init,1),6)';
Ybus = Ygen(Ofname); % Ybus ����.
SelectSolution = input('Gauss-Seidal��:1, Newton-Raphson��:2    > ','s');
if SelectSolution == '1' [Po,Qo,Vo,Ao,EP,EQ,t]=GsSd(Vi,Ai,Pi,Qi,BusType,Ybus); %Gauss-Seidal��
else [Po,Qo,Vo,Ao,EP,EQ,t]=NtRs(Vi,Ai,Pi,Qi,BusType,Ybus); %Newton-Raphson��
end
input('< Press ENTER KEY to continue >')
%-------------���żӵ� �׷���-------------
Ao=(mod(Ao+pi,2*pi)-pi)*180/pi;
figure(1)
plot(t,[EP;EQ],'-o'); grid on; title('�ִ� �������� ���Ű���');
legend('P','Q'); xlabel('�ݺ�ȸ��'); ylabel('�������� �ִ� ��(%)');
figure(2)
subplot(2,2,1); plot([0 t],Po,'-o'); grid on; title('<P�� ���Ű���>');
xlabel('�ݺ�ȸ��'); ylabel('P');
subplot(2,2,2); plot([0 t],Qo,'-o'); grid on; title('<Q�� ���Ű���>');
xlabel('�ݺ�ȸ��'); ylabel('Q');
subplot(2,2,3); plot([0 t],Vo,'-o'); grid on; title('<V�� ���Ű���>');
xlabel('�ݺ�ȸ��'); ylabel('V');
subplot(2,2,4); plot([0 t],Ao,'-o'); grid on; title('<�谪 ���Ű���>');
xlabel('�ݺ�ȸ��'); ylabel('��');
%---------------��� ���----------------
itN = length([0 t]);
fprintf('\n< �ʱ� ���� �� >')
fprintf('\n%3s %6s %10s %15s %15s %16s\n','BusNum','Type','P','Q','V','��')
fprintf('%4d %8d %15.4f %15.4f %15.4f %15.4f\n',[[1:length(BusType)].' ...
    BusType.' Pi Qi Vi Ai].')
fprintf('\n< ��� �� >')
fprintf('\n%3s %6s %10s %15s %15s %16s\n','BusNum','Type','P','Q','V','��')
fprintf('%4d %8d %15.4f %15.4f %15.4f %15.4f\n',[[1:length(BusType)].' ...
    BusType.' Po(:,itN) Qo(:,itN) Vo(:,itN) Ao(:,itN)].');
ResultF = fopen('data\Result.csv','w+');
fprintf(ResultF,'%s,%s,%s,%s,%s,%s\n','BusNum','Type','P','Q','V','��');
fprintf(ResultF,'%d,%d,%f,%f,%f,%f\n',[[1:length(BusType)].' ...
    BusType.' Po(:,itN) Qo(:,itN) Vo(:,itN) Ao(:,itN)].');
fclose(ResultF);
fprintf('\n��� ���� ���� : "data\\Result.csv"\n');
fclose('all');
if input('�ٽ� ���?(Y) : ','s') == 'Y' powersys_total; end
P=Po;Q=Qo;V=Vo;A=Ao;
end

function Ybus = Ygen(filename) %Ybus ��Ʈ���� ���� function
RXB = xlsread(filename,2);
M = size(RXB,1); % ����Ÿ �� ��
N = max(max(RXB(:,1:2))); % �� �� ����
R=ones(N,N)*realmax; X=ones(N,N)*realmax; % ����, �����Ͻ� ��Ʈ���� ����� ���Ѵ�� ä��
B=zeros(N,N); G=zeros(N,N); % �����Ͻ�, �����Ͻ� ��Ʈ������ �� ���� ����
for n = 1:M
    if RXB(n,1)~=RXB(n,2) % ������ ���ķ� ����� �����Ͻ� �ϰ�� ��
        R(RXB(n,1),RXB(n,2)) = RXB(n,3); % ���� �� ����
        R(RXB(n,2),RXB(n,1)) = RXB(n,3); % ��Ī ��Ĳ÷� ����
        X(RXB(n,1),RXB(n,2)) = RXB(n,4); % �����Ͻ� �� ����
        X(RXB(n,2),RXB(n,1)) = RXB(n,4); % ��Ī ��Ĳ÷� ����
    end
    B(RXB(n,1),RXB(n,2)) = RXB(n,5); % �����Ͻ� �� ����
    G(RXB(n,1),RXB(n,2)) = RXB(n,6); % �����Ͻ� �� ����
end
G = G + G.'; % �����Ͻ��� ��Ī��Ĳ÷�, �밢������ 2��
B = B + B.'; % �����Ͻ��� ��Ī��Ĳ÷�, �밢������ 2��
Y = (R+X*i).^(-1) + (ones(N,1)*sum(B*i+G)/2.*eye(N)); % �����Ͻ� ��Ʈ���� ���
Ybus = zeros(N,N); % Ybus ���� �غ�
    for u=1:N % Ybus ���ȣ
        for j=u:N % Ybus ����ȣ
            if (u==j) % �밢����
                for k = 1:N
                    Ybus(u,j) = Ybus(u,j)+Y(u,k);
                end
            else % ��밢����
                Ybus(j,u) = -Y(u,j); % ��Ī ��Ĳ÷� ����
                Ybus(u,j) = -Y(u,j);
            end
        end
    end
    Ybus = round(Ybus*10^5)*10^-5; % Ybus �Ҽ����Ʒ� 5��° ���� ��Ÿ��.
end

function [P Q] = PWCal(Y,Vmag,A) % ���¹�����
V=Vmag.*(cos(A)+sin(A)*i); % V = Vmag�Х�
S=V.*conj(Y*V); % S = V.*conj(I)
P=real(S);
Q=imag(S);
end

function [J11,J12,J21,J22] = JacobiM(Ybus,V,A) %Jacobian Matrix ���� �Լ�
G = real(Ybus); % �����Ͻ�
B = imag(Ybus); % �����Ͻ�
numtotal = length(V); % �� �� ����
%J11
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % �밢����
            J11(n,n) = V(n)*G(n,n);
            for i = 1:numtotal
                Ani = A(n)-A(i); % ������ ���
                sumJ = V(i)*(G(n,i)*cos(Ani)+B(n,i)*sin(Ani)); % �ñ׸� �κ�
                J11(n,n) = J11(n,n) + sumJ; % �ñ׸� ����
            end
        else % ��밢����
            Ani = A(n)-A(m); % ������ ���
            J11(n,m) = V(n)*(G(n,m)*cos(Ani)+B(n,m)*sin(Ani));
        end
    end
end
%J12
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % �밢����
            J12(n,n) = 0;
            for i = 1:numtotal
                if n==i continue; end
                Ani = A(n)-A(i); % ������ ���
                sumJ = V(i)*V(n)*(-G(n,i)*sin(Ani)+B(n,i)*cos(Ani)); % �ñ׸� �κ�
                J12(n,n) = J12(n,n) + sumJ; % �ñ׸� ����
            end
        else % ��밢����
            Ani = A(n)-A(m); % ������ ���
            J12(n,m) = V(n)*V(m)*(G(n,m)*sin(Ani)-B(n,m)*cos(Ani));
        end
    end
end
%J21
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % �밢����
            J21(n,n) = -V(n)*B(n,n);
            for i = 1:numtotal
                Ani = A(n)-A(i); % ������ ���
                sumJ = V(i)*(G(n,i)*sin(Ani)-B(n,i)*cos(Ani)); % �ñ׸� �κ�
                J21(n,n) = J21(n,n) + sumJ; % �ñ׸� ����
            end
        else % ��밢����
            Ani = A(n)-A(m); % ������ ���
            J21(n,m) = V(n)*(G(n,m)*sin(Ani)-B(n,m)*cos(Ani));
        end
    end
end
%J22
for n = 1:numtotal
    for m = 1:numtotal
        if n==m % �밢����
            J22(n,n) = 0;
            for i = 1:numtotal
                if n==i continue; end
                Ani = A(n)-A(i);
                sumJ = V(i)*V(n)*(B(n,i)*sin(Ani)+G(n,i)*cos(Ani)); % �ñ׸� �κ�
                J22(n,n) = J22(n,n) + sumJ; % �ñ׸� ����
            end
        else % ��밢����
            Ani = A(n)-A(m);
            J22(n,m) = -V(n)*V(m)*(G(n,m)*cos(Ani)+B(n,m)*sin(Ani));
        end
    end
end
end

function [Po,Qo,Vo,Ao,EP,EQ,t]=GsSd(Vi,Ai,Pi,Qi,BusType,Ybus) %Gauss-Seidal��
P = Pi; Q= Qi; V = Vi; A = Ai;

numgen = length(find(BusType==2)); % ������ ������ ������ ����
numload = length(find(BusType==3)); % ���ϸ� ����
numtotal = numgen + numload + 1; % �� �� ��

%---------------��Ͽ� ����-------------
Preal = P; Qreal = Q; count = 0; % ���, ī���� �ʱ�ȭ
Po=Preal; Qo=Qreal; Vo=V; Ao=A; t=[];EP=[];EQ=[]; % ��Ͽ� ������
%------------Gauss-Seidal�� ����------------
while(1)
    count = count+1; % ī����
    P = BusSort(P,BusType,[2 3],4,Pi);
    Q = BusSort(Q,BusType,[3],4,Qi);
    for N=1:numtotal
        [V,A]=voltheta(Ybus,V,A,P+Q*i);
        V = BusSort(V,BusType,[1 2],4,Vi);
        A = BusSort(A,BusType,[1],4,Ai);
    end
    [P Q] = PWCal(Ybus,V,A); % ���°��
    %-------------------���---------------------
    Po =[Po P];  Qo =[Qo Q];
    Vo =[Vo V];  Ao =[Ao A];
    %----------�ݺ���� ������ ���� �Ǵ�----------
    % 0���� �������� ��� 0��� realmin���� ��� ��.
    if find(Po(:,count+1)==0) Po(find(Po(:,count+1)==0),count+1)=realmin; end
    if find(Qo(:,count+1)==0) Qo(find(Qo(:,count+1)==0),count+1)=realmin; end
    % P�� Q�� ���������� ����������� ���� ū ���� ��������
    errP = max(abs((Po(:,count+1) - Po(:,count))./Po(:,count+1)*100));
    errQ = max(abs((Qo(:,count+1) - Qo(:,count))./Qo(:,count+1)*100));
    EP = [EP errP]; EQ = [EQ errQ]; % ������ ���
    t = [t count]; % ī���� ���
    % 0.001%������ �������Ǵ� 50ȸ�̻� �ݺ����� ����
    if count>50|(errP<0.0001&errQ<0.0001) break; end 
    
end
end

function [V,A]=voltheta(Ybus,V,A,S) %Gauss Seidal������ ����, ���� ���ϴ� �Լ�
   vt=V.*(cos(A)+sin(A)*i);
   vt = (conj(S./vt)-Ybus*vt+(diag(Ybus)).*vt)./(diag(Ybus));
   V = abs(vt);
   A = angle(vt);
end

function [Po,Qo,Vo,Ao,EP,EQ,t]=NtRs(Vi,Ai,Pi,Qi,BusType,Ybus) %Newton-Raphson��
P = Pi; Q= Qi; V = Vi; A = Ai;

numgen = length(find(BusType==2)); % ������ ������ ������ ����
numload = length(find(BusType==3)); % ���ϸ� ����
numtotal = numgen + numload + 1; % �� �� ��

%---------------��Ͽ� ����-------------
Preal = P; Qreal = Q; count = 0; % ���, ī���� �ʱ�ȭ
Po=Preal; Qo=Qreal; Vo=V; Ao=A; t=[];EP=[];EQ=[]; % ��Ͽ� ������
%------------���϶��չ� ����------------
while(1)
    count = count+1; % ī����
    %-����, �������� ����, ���� ��ȭ ���-
    [P Q] = PWCal(Ybus,V,A); % ���°��
    dP = Preal-P;           dQ = Qreal-Q;
    %---------���ں�� ��� ����� �籸��----------
    % J11���� ����,������ �� ����, ������ �� ����
    % J12���� ������ �� ����, ������ �� ����
    % J11���� ����,������ �� ����, ����,������ �� ����
    % J11���� ������ �� ����, ����,������ �� ����
    [J11,J12,J21,J22] = JacobiM(Ybus,V,A);
    J11 = BusSort(J11,BusType,[3],1); J11 = BusSort(J11,BusType,[2 3],2);
    J12 = BusSort(J12,BusType,[2 3],1); J12 = BusSort(J12,BusType,[2 3],2);
    J21 = BusSort(J21,BusType,[3],1); J21 = BusSort(J21,BusType,[3],2);
    J22 = BusSort(J22,BusType,[2 3],1); J22 = BusSort(J22,BusType,[3],2);
    J=[J11 J12;J21 J22];
    %-----------������ P,Q������ �籸��------------
    dP0 = BusSort(dP,BusType,[2 3],2);% dP0�� ������ ����
    dQ0 = BusSort(dQ,BusType,[3],2); % dQ0�� ����,������ ����
    %---------����, ������ ��ȭ �� ���----------
    dVdA = J\[dP0;dQ0]; %J\[dP0;dQ0]
    %dVdA : [dV�� ���ϸ�; dA�� ����,���ϸ�]
    dV0 = dVdA(1:numload); % dV0�и�
    dA0 = dVdA(1+numload:size(dVdA)); %dA0�и�
    % dV �籸�� : dV�� ����,������ �κ��� 0�����ϰ� (���ϸ�)dV0 ����
    dV=BusSort(zeros(numtotal,1),BusType,[3],2,dV0);
    % dA �籸�� : dA�� ������ �κ��� 0�����ϰ�
    % (������ ������ ��������) dA0 ����
    dA=BusSort(zeros(numtotal,1),BusType,[2 3],2,dA0);
    %------------����, ���� �� ����-------------
    V = V+dV;           A = mod(A+dA,2*pi);
    %-------P,Q ���ذ�(����)���� Preal,Qreal------
    % ������ P,Q �������� Q�� ������ �𸣱� ������ ����.
    Preal=BusSort(Preal,BusType,[1],4,P);
    Qreal=BusSort(Qreal,BusType,[1 2],4,Q);
    %-------------------���---------------------
    Po =[Po P];  Qo =[Qo Q];
    Vo =[Vo V];  Ao =[Ao A];
    %----------�ݺ���� ������ ���� �Ǵ�----------
    % 0���� �������� ��� 0��� realmin���� ��� ��.
    if find(Po(:,count+1)==0) Po(find(Po(:,count+1)==0),count+1)=realmin; end
    if find(Qo(:,count+1)==0) Qo(find(Qo(:,count+1)==0),count+1)=realmin; end
    % P�� Q�� ���������� ����������� ���� ū ���� ��������
    errP = max(abs((Po(:,count+1) - Po(:,count))./Po(:,count+1)*100));
    errQ = max(abs((Qo(:,count+1) - Qo(:,count))./Qo(:,count+1)*100));
    EP = [EP errP]; EQ = [EQ errQ]; % ������ ���
    t = [t count]; % ī���� ���
    % 0.001%������ �������Ǵ� 50ȸ�̻� �ݺ����� ����
    if count>50|(errP<0.001&errQ<0.001) break; end 
end
end

function M = BusSort(M,BusType,K,n,N) % Newton-Raphson������ ������ �������� ���� Newton-Raphson�� �������ִ� �Լ�
if nargin<5|isempty(N),N = [];end
% N = []�϶�,
% M��Ʈ�������� BusType�� K�� (n=1 :��, n~=1 :��)�� �����ϴ� function

% N = ���� ���� ��,
% n = 1 or 2
% M��Ʈ�������� BusType�� K�� (n=1 :��, n=2 :��)��
% ���������� N��Ʈ������ (n=1:��,n=2:��)�� �ٲ���.
% n = 3 or 4
% M��Ʈ�������� BusType�� K�� (n=3 :��, n=�׿� :��)��
% N��Ʈ������ ���� ��ġ�� (n=3:��,n=else:��)�� �ٲ���.

% K = [x x x x .... x] ����...
Nbus=[];
for m=1:size(K,2)
    [a,nbus] = find(BusType==K(m));
    Nbus=[Nbus nbus];
end
if size(N)==0
    if n==1 %���η� ����
        usedbusnum = sort(Nbus); M=M(:,usedbusnum);
    else %���η� ����
        usedbusnum = sort(Nbus); M=M(usedbusnum,:);
    end
else
    if n==1 %���η� ����
        usedbusnum = sort(Nbus); M(:,usedbusnum)=N(:,:);
    elseif n==2 %���η� ����
        usedbusnum = sort(Nbus); M(usedbusnum,:)=N(:,:);
    elseif n==3 %���η� ����
        usedbusnum = sort(Nbus); M(:,usedbusnum)=N(:,usedbusnum);
    else %���η� ����
        usedbusnum = sort(Nbus); M(usedbusnum,:)=N(usedbusnum,:);
    end
end
end
