
    format long
    vk = @(f,Re) 4*log10(Re*sqrt(f))-0.4-1/sqrt(f);
    M = [];
    M(1,1:4) = 2500;
    M(2,1:4) = 3000;
    M(3,1:4) = 10000;
    M(4,1:4) = 30000;
    M(5,1:4) = 100000;
    M(6,1:4) = 300000;
    M(7,1:4) = 1000000;
    fprintf('Re\t\tRoot\t\tTruth\t\tEt\n')
    for i=1:1:7
    M(i,2) = fanning(vk,0.0028,0.012,M(i,1));
    M(i,3) = bisect(vk,0.0028,0.012,0.0000001,1000,M(i,1));
    M(i,4) = abs(M(i,2)-M(i,3));
    fprintf('%d\t%f\t%f\t%e\n',M(i,1),M(i,2),M(i,3),M(i,4))
    end

    
    
    