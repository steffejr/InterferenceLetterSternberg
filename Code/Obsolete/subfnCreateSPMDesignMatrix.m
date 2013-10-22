function [names durations onsets] = subfnCreateSPMDesignMatrix(ExperimentParameters)
% Create the structures needed to create an SPM5/8 design matrix.
% These are the names/durations and onsets.
% Note that a trial is said to be INCORRECT if either the letter task OR
% the number task is incorrect.
%
LoadLevels = unique(ExperimentParameters.Design(:,1));
NumLevels = unique(ExperimentParameters.Design(:,2));
NLoad = length(LoadLevels);
NNum = length(NumLevels);
%RetCond = {'LowNEG' 'HighNEG' 'LowPOS' 'HighPOS'};
RetCond = {'Low' 'High'};
    
names = {};

count = 1;
for i = 1:NLoad
    names{count} = ['Stm' num2str(LoadLevels(i))];
    count = count + 1;
end
if NNum > 1
    for i = 1:NLoad
        for j = 1:length(RetCond)
            names{count} = ['Ret' num2str(LoadLevels(i)) RetCond{j}];
            count = count + 1;
        end
    end
else
end
for i = 1:NLoad 
    names{count} = ['Pro' num2str(LoadLevels(i)) 'Low'];
    count = count + 1;
    names{count} = ['Pro' num2str(LoadLevels(i)) 'High'];
    count = count + 1;
end

names{count} = 'IncStm';
count = count + 1;
names{count} = 'IncRet';
count = count + 1;
names{count} = 'IncPro';
count = count + 1;


NCond = length(names);
NTrials = length(ExperimentParameters.Trials);
DUR = zeros(NTrials,NCond);
ONSETS = zeros(NTrials,NCond);

DurStm = zeros(NTrials,NLoad*1+1);
DurRet = zeros(NTrials,NLoad*2+1);
DurPro = zeros(NTrials,NLoad*2+1);
OnsStm = zeros(NTrials,NLoad*1+1);
OnsRet = zeros(NTrials,NLoad*2+1);
OnsPro = zeros(NTrials,NLoad*2+1);

for i = 1:NTrials
    Trial = ExperimentParameters.Trials{i};
    % LETTER CORRECT
    if (strcmp(Trial.LetterResponseAcc,'HT') || strcmp(Trial.LetterResponseAcc,'CR'))&(strcmp(Trial.NumberResponseAcc,'HT') || strcmp(Trial.NumberResponseAcc,'CR'))
        for j = 1:NLoad
            if str2num(Trial.LetType(1)) == LoadLevels(j)
                CurrentRT = Trial.LetterResponseTime(max(find(Trial.LetterResponseTime ~= -99)));
                DurStm(i,j) = Trial.PreRetStartTime - Trial.EncodeStartTime;  
                OnsStm(i,j) = Trial.EncodeStartTime;                      
                    if ~isempty(strfind(Trial.NumType,'Low'))
                        DurRet(i,((j-1)*NLoad+1)) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                        OnsRet(i,((j-1)*NLoad+1)) = Trial.RetentionStartTime;
                        ONSETS(i,3) = Trial.RetentionStartTime;
                    elseif ~isempty(strfind(Trial.NumType,'High'))
                        DurRet(i,((j-1)*NLoad+2)) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                        OnsRet(i,((j-1)*NLoad+2)) = Trial.RetentionStartTime;
                        ONSETS(i,4) = Trial.RetentionStartTime;
%                     elseif strcmp(Trial.NumType,'LowPOS')
%                         DurRet(i,((j-1)*4+3)) = Trial.PostRetStartTime - Trial.RetentionStartTime;
%                         OnsRet(i,((j-1)*4+3)) = Trial.RetentionStartTime;
%                         ONSETS(i,5) = Trial.RetentionStartTime;
%                     elseif strcmp(Trial.NumType,'HighPOS')
%                         DurRet(i,((j-1)*4+4)) = Trial.PostRetStartTime - Trial.RetentionStartTime;
%                         OnsRet(i,((j-1)*4+4)) = Trial.RetentionStartTime;
%                         ONSETS(i,6) = Trial.RetentionStartTime;
                    end                
                
                
                if ~isempty(strfind(Trial.LetType,[num2str(LoadLevels(j))]) & strfind(Trial.NumType,'Low'))
                    DurPro(i,(j-1)*NLoad+1) = CurrentRT;
                    OnsPro(i,(j-1)*NLoad+1) = Trial.ProbeStartTime; 
                    ONSETS(i,13) = Trial.ProbeStartTime;
                elseif ~isempty(strfind(Trial.LetType,[num2str(LoadLevels(j))]) & strfind(Trial.NumType,'High'))
                    DurPro(i,(j-1)*NLoad+2) = CurrentRT;
                    OnsPro(i,(j-1)*NLoad+2) = Trial.ProbeStartTime;
                    ONSETS(i,13) = Trial.ProbeStartTime;
                end

                %ONSETS(i,1) = Trial.EncodeStartTime;                        %Stm2
                %DUR(i,5) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                %ONSETS(i,5) = Trial.RetentionStartTime;
                
                % NUMBER CORRECT
                %if strcmp(Trial.NumberResponseAcc,'HT') || strcmp(Trial.NumberResponseAcc,'CR')

               % else
                  %  DurRet(i,end) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                  %  OnsRet(i,end) = Trial.RetentionStartTime;
                %end
            end
        end
    else% strcmp(Trial.LetterResponseAcc,'MS') || strcmp(Trial.LetterResponseAcc,'FA') || 
        CurrentRT = Trial.LetterResponseTime(max(find(Trial.LetterResponseTime ~= -99)));
        DurStm(i,end) = Trial.PreRetStartTime - Trial.EncodeStartTime;
        DurRet(i,end) = Trial.PostRetStartTime - Trial.RetentionStartTime;
        DurPro(i,end) = CurrentRT;
        OnsStm(i,end) = Trial.EncodeStartTime;  
        OnsRet(i,end) = Trial.RetentionStartTime;
        OnsPro(i,end) = Trial.ProbeStartTime;
    end
end

TempOnsets = [OnsStm(:,1:end-1) OnsRet(:,1:end-1) OnsPro(:,1:end-1) OnsStm(:,end) OnsRet(:,end) OnsPro(:,end)];
TempDurs = [DurStm(:,1:end-1) DurRet(:,1:end-1) DurPro(:,1:end-1) DurStm(:,end) DurRet(:,end) DurPro(:,end)];
onsets = {};
durations = {};
for i = 1:length(names)
    F = find(TempOnsets(:,i));
    onsets{i} = TempOnsets(F,i);
    durations{i} = TempDurs(F,i);
end
% Remove empty conditions
F = ones(length(onsets),1);
for i = 1:length(onsets)
    if ~length(onsets{i})
        F(i) = 0;
    end
end
onsets = onsets(find(F));
durations = durations(find(F));
names = names(find(F));

