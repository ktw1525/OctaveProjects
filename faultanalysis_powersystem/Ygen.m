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

