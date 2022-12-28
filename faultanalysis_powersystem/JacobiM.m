function [J11,J12,J21,J22] = JacobiM(Ybus,V,A)
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