function [names onsets durations] = subfnCreateRegressors(Trials, Events)

NTrials = length(Trials);
names = {};
DUR = zeros(NTrials,4);
ONS = zeros(NTrials,4);
NEvents = length(Events);
% There are FOUR different regressors which correspond to the four EVENTS
for i = 1:NEvents
    names{i} = Events{i}.name;
end

for i = 1:NTrials
    % for each trial detremine which condition it belongs to
    for j = 1:NEvents
        if ~isempty(strmatch(Events{j}.name, Trials{i}.name))
%             Events{j}.name;
            break
        end
    end
    %DUR(i,j) = [Trials{i}.ResponseTime];
    DUR(i,j) = Trials{i}.Visual.duration + Trials{i}.Auditory.duration + Trials{i}.ResponseTime;
    ONS(i,j) = [Trials{i}.Visual.ActualOn];
    % was there a response?
end

        
onsets = {};
durations = {};
NotEmpty = zeros(NEvents,1);
for i = 1:NEvents
    onsets{i} = ONS(find(ONS(:,i)),i);
    durations{i} = DUR(find(DUR(:,i)),i);
    if length(durations{i})
        NotEmpty(i) = 1;
    end
end        
