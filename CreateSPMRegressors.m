function [names onsets durations] = CreateSPMRegressors(Trials)

Phases = {'Stm' 'Ret' 'Pro'};
LetLoad = {'1' '2'  '3' '6'};
NumLoad = {'Low' 'High'};
%NumLoad = {'Low'};
Response = {'Cor' 'Inc'};
ProbeType = {'POS' 'NEG'};   
ProbeType = {''};
DurTimes = [3 7 -1 3];

NPhase = length(Phases);
NLetLoad = length(LetLoad);
NNumLoad = length(NumLoad);
NResp = length(Response);
NProbeType = length(ProbeType);

names = {};
count = 1;
% Stimulus
for i = 1:NLetLoad
    names{count} = [Phases{1} LetLoad{i}];
    count = count + 1;
end
% Retention
  %'Ret2LowNEG'
for i = 1:NProbeType
    for j = 1:NNumLoad
        for k = 1:NLetLoad
            names{count} = [Phases{2} LetLoad{k} NumLoad{j} ProbeType{i}];
            count = count + 1;
        end
    end
end
% Probe
for i = 1:NProbeType
    for j = 1:NNumLoad
        for k = 1:NLetLoad
            names{count} = [Phases{3} LetLoad{k} NumLoad{j} ProbeType{i}];
            count = count + 1;
        end
    end
end        
for i = 1:NPhase
    names{count} = ['Inc' Phases{i}];
    count = count + 1;
end

%%
NCond = length(names);
NTrials = length(Trials);
DUR = zeros(NTrials,NCond);
ONSETS = zeros(NTrials,NCond);

for i = 1:NTrials
    Trial = Trials{i};
    % What is the load level?
    CurrentLetLoad = Trial.LetType(1);
    CurrentNumLoad = Trial.NumType(1:3);
    % Is this trial correct?
    if strcmp(Trial.LetterResponseAcc,'HT') || strcmp(Trial.LetterResponseAcc,'CR')
        for j = 1:NCond
            % Find the names with the same Letter Load level
            if ~isempty(findstr(names{j},CurrentLetLoad)) 
                % Check Each Phase
                for k = 1:length(Phases)
                    if ~isempty(strfind(names{j},Phases{k}))
                        if k == 1
                            ONSETS(i,j) = Trial.EncodeStartTime;
                            DUR(i,j) = DurTimes(k);
                        elseif k == 2 & ~isempty(findstr(names{j},CurrentNumLoad))
                            ONSETS(i,j) = Trial.RetentionStartTime;
                            DUR(i,j) = DurTimes(k);
                        elseif k == 3 & ~isempty(findstr(names{j},CurrentNumLoad))
                            ONSETS(i,j) = Trial.ProbeStartTime;
                            if DurTimes(k) > 0;
                                DUR(i,j) = DurTimes(k);
                            else
                                % What is the Trial specific Response Time
                                DUR(i,j) = Trial.LetterResponseTime(max(find(Trial.LetterResponseTime>-99)));
                            end
                            
                        end
                        
                        %Trial.LetType
                        %Trial.LetterResponseAcc
                    end
                end
            end
        end
    else
         for j = 1:NCond
            % Find the names with the same Letter Load level
            if ~isempty(findstr(names{j},'Inc')) 
                % Check Each Phase
                for k = 1:length(Phases)
                    if ~isempty(strfind(names{j},Phases{k}))
                        if k == 1
                            ONSETS(i,j) = Trial.EncodeStartTime;
                            DUR(i,j) = DurTimes(k);
                        elseif k == 2 
                            ONSETS(i,j) = Trial.RetentionStartTime;
                            DUR(i,j) = DurTimes(k);
                        elseif k == 3 
                            ONSETS(i,j) = Trial.ProbeStartTime;
                          %    if DurTimes(k) > 0;
                                DUR(i,j) = DurTimes(4);
                          %  else
                           %     % What is the Trial specific Response Time
                            %    DUR(i,j) = Trial.LetterResponseTime(max(find(Trial.LetterResponseTime>-99)));
                          %  end
                        end
                        
                        %Trial.LetType
                        %Trial.LetterResponseAcc
                    end
                end
            end
         end
    end
end        

    
%% Clean up
% If the number load length is ONE, then remove 'Low' From the names
CleanNames = names;    
if length(NumLoad)<2
    for i = 1:NCond
        if ~isempty(strfind(names{i},'Low'))
            CleanNames{i} = names{i}(1:end-3);
        end
    end
end
names = CleanNames;
onsets = {};
durations = {};
NotEmpty = zeros(NCond,1);
for i = 1:NCond
    onsets{i} = ONSETS(find(ONSETS(:,i)),i);
    durations{i} = DUR(find(DUR(:,i)),i);
    if length(durations{i})
        NotEmpty(i) = 1;
    end
end
NotEmpty = find(NotEmpty);
durations = durations(NotEmpty);
onsets = onsets(NotEmpty);
names = names(NotEmpty);
