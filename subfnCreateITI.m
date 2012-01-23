function ITI = subfnCreateITI(NTrials)
% Create the ITI distribution for the Cognitive Reserve studies
NITIs = round(NTrials*(140/30)/2)
%NITIs = 70;
%NTrials = 30;
Limit = 4;
flag = 1;
while flag
    %R = [ceil(rand(NITIs - NTrials,1)*NTrials)]; [1:30]'];
    % Make this PSEUDORANDOM by making sure that there at least one 2
    % second blank block at the end of the experiment
    R = ceil(rand(NITIs,1)*NTrials);
    sR = sort(R);
    count = zeros(NTrials,1);
    for i = 1:NTrials
        count(i) = sum(R==i);
    end
    if isempty(find(count > Limit)) & count(end)>0
        flag = 0;
    end
end
ITI = count * 2;
%% Add 3 seconds between each trial as a BASE ITI
ITI = ITI + 3;
sum(ITI);

% NITIs = round(NTrials*(140/30)/2)
% %NITIs = 70;
% %NTrials = 30;
% Limit = 4;
% flag = 1;
% while flag
%     R = [ceil(rand(NITIs - NTrials,1)*NTrials); [1:30]'];
%     sR = sort(R);
%     count = zeros(NTrials,1);
%     for i = 1:NTrials
%         count(i) = sum(R==i);
%     end
%     if isempty(find(count > Limit))
%         flag = 0;
%     end
% end
% ITI = count * 2;
% sum(ITI);