function ITI = subfnCreate140secITI
NITIs = 70;
NTrials = 30;
Limit = 4;
flag = 1;
while flag
    R = [ceil(rand(NITIs - NTrials,1)*NTrials); [1:30]'];
    sR = sort(R);
    count = zeros(NTrials,1);
    for i = 1:NTrials
        count(i) = sum(R==i);
    end
    if isempty(find(count > Limit))
        flag = 0;
    end
end
ITI = count * 2