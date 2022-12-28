function M = BusSort(M,BusType,K,n,N)
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