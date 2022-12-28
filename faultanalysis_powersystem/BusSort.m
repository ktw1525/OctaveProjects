function M = BusSort(M,BusType,K,n,N)
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