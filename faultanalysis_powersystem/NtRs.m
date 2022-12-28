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
