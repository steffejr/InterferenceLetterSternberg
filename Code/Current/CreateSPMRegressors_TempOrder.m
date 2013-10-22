function [names onsets durations] = CreateSPMRegressors_TempOrder(Trials)
% These need to be split into EASY and HARD conditions
% There are 40 trials:
% 20 AV
% 20 VA
% 10 A1V1
names = {};
names{1} = 'V1A1';
names{2} = 'V1A2';
names{3} = 'V2A1';
names{4} = 'V2A2';
names{5} = 'A1V1';
names{6} = 'A1V2';
names{7} = 'A2V1';
names{8} = 'A2V2';

onsets = {};
durations = {};
for i = 1:length(names)
    onsets{i} = [];
end
NTrials = length(Trials);
AVons = [];
VAons = [];
offset = 0.5;
for i = 1:NTrials
    for j = 1:length(names)
        if strmatch(Trials{i}.name,names{j})
            if j < 5
                onsets{j} = [onsets{j}; Trials{i}.Visual.ActualOn + offset];
            else
                onsets{j} = [onsets{j};  Trials{i}.Auditory.ActualOn + offset];
            end
        end
    end
end
for i = 1:length(names)
    durations{i} = zeros(size(onsets{i}));
end

