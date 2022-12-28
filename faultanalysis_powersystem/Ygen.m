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

