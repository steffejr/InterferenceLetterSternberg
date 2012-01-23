function [medRT propCor] = subfnTempOrderResults(Trials)
NTrials = length(Trials);
RT = zeros(NTrials,1);
for i = 1:NTrials
    if length(Trials{i}.ResponseKey)>0
        RT(i) = Trials{i}.ResponseTime;
    end
end

medRT = median(RT(find(RT)));
propCor = length(find(RT))/length(RT)*100;