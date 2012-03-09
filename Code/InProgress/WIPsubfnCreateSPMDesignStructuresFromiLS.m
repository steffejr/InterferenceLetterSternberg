function [OutPutDesign] = WIPsubfnCreateSPMDesignStructuresFromiLS(ExperimentParameters);
% Model correct
% Model incorrect but collapse across load

% Factors
LetterLoad = [2 6];
NumLoad = [0 1];
% Here the retention conditions are split into 8 different ways; therefore,
% there are at most 6 trials per condition. This is assuming all are
% correct.
% What about correct letter with incorrect number?
names = ...
    {'Stm2' ...         % 1
    'Stm6' ...          % 2
    'Ret2LowNEG' ...    % 3
    'Ret2HighNEG' ...   % 4
    'Ret2LowPOS' ...    % 5
    'Ret2HighPOS' ...   % 6
    'Ret6LowNEG' ...    % 7
    'Ret6HighNEG' ...   % 8
    'Ret6LowPOS' ...    % 9
    'Ret6HighPOS' ...   % 10
    'Pro2NEG' ...       % 11
    'Pro6NEG' ...       % 12
    'Pro2POS' ...       % 13
    'Pro6POS' ...       % 14
    'IncStm' ...        % 15
    'IncRet' ...        % 16
    'IncPro'}           % 17
NCond = length(names)
NTrials = length(ExperimentParameters.Trials)
DUR = zeros(NTrials,NCond);
ONSETS = zeros(NTrials,NCond);
for i = 1:NTrials
    Trial = ExperimentParameters.Trials{i};
    % LETTER CORRECT
    if strcmp(Trial.LetterResponseAcc,'HT')
        % POSITIVE
        % 2 Let
        if strcmp(Trial.LetType,'2POS')
            DUR(i,1) = Trial.PreRetStartTime - Trial.EncodeStartTime;   %Stm2
            ONSETS(i,1) = Trial.EncodeStartTime;                        %Stm2
            %DUR(i,5) = Trial.PostRetStartTime - Trial.RetentionStartTime;
            %ONSETS(i,5) = Trial.RetentionStartTime;
            CurrentRT = Trial.NumberResponseTime(max(find(Trial.NumberResponseTime ~= -99)));
            DUR(i,13) = CurrentRT; %Trial.ITIStartTime - Trial.ProbeStartTime;
            ONSETS(i,13) = Trial.ProbeStartTime;
            % NUMBER CORRECT
            if strcmp(Trial.NumberResponseAcc,'HT') || strcmp(Trial.NumberResponseAcc,'CR')
                if strcmp(Trial.NumType,'LowNEG')
                    DUR(i,3) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,3) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighNEG')
                    DUR(i,4)  = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,4) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'LowPOS')
                    DUR(i,5) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,5) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighPOS')
                    DUR(i,6) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,6) = Trial.RetentionStartTime;
                end
            end
        
        % 6 Let
        elseif strcmp(Trial.LetType,'6POS')
            DUR(i,2) = Trial.PreRetStartTime - Trial.EncodeStartTime;   %Stm6
            ONSETS(i,2) = Trial.EncodeStartTime;                        %Stm6
            %DUR(i,6) = Trial.PostRetStartTime - Trial.RetentionStartTime;
            %ONSETS(i,6) = Trial.RetentionStartTime;
            CurrentRT = Trial.NumberResponseTime(max(find(Trial.NumberResponseTime ~= -99)));
            DUR(i,14) = CurrentRT; %Trial.ITIStartTime - Trial.ProbeStartTime;
            ONSETS(i,14) = Trial.ProbeStartTime;
            % NUMBER CORRECT
            if strcmp(Trial.NumberResponseAcc,'HT') || strcmp(Trial.NumberResponseAcc,'CR')
                if strcmp(Trial.NumType,'LowNEG')
                    DUR(i,7) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,7) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighNEG')
                    DUR(i,8)  = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,8) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'LowPOS')
                    DUR(i,9) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,9) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighPOS')
                    DUR(i,10) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,10) = Trial.RetentionStartTime;
                end
            end
        end
    elseif strcmp(Trial.LetterResponseAcc,'CR')
        % NEGATIVE
        % 2 Let
        if strcmp(Trial.LetType,'2NEG')
            DUR(i,1) = Trial.PreRetStartTime - Trial.EncodeStartTime;   %Stm2
            ONSETS(i,1) = Trial.EncodeStartTime;                        %Stm2
            %DUR(i,5) = Trial.PostRetStartTime - Trial.RetentionStartTime;
            %ONSETS(i,5) = Trial.RetentionStartTime;
            CurrentRT = Trial.NumberResponseTime(max(find(Trial.NumberResponseTime ~= -99)));
            DUR(i,11) = CurrentRT; %Trial.ITIStartTime - Trial.ProbeStartTime;
            ONSETS(i,11) = Trial.ProbeStartTime;
            % NUMBER CORRECT
            if strcmp(Trial.NumberResponseAcc,'HT') || strcmp(Trial.NumberResponseAcc,'CR')
                if strcmp(Trial.NumType,'LowNEG')
                    DUR(i,3) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,3) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighNEG')
                    DUR(i,4)  = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,4) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'LowPOS')
                    DUR(i,5) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,5) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighPOS')
                    DUR(i,6) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,6) = Trial.RetentionStartTime;
                end
            end
        
        % 6 Let
        elseif strcmp(Trial.LetType,'6NEG')
            DUR(i,2) = Trial.PreRetStartTime - Trial.EncodeStartTime;   %Stm6
            ONSETS(i,1) = Trial.EncodeStartTime;                        %Stm6
            %DUR(i,6) = Trial.PostRetStartTime - Trial.RetentionStartTime;
            %ONSETS(i,5) = Trial.RetentionStartTime;
            CurrentRT = Trial.NumberResponseTime(max(find(Trial.NumberResponseTime ~= -99)));
            DUR(i,12) = CurrentRT; %Trial.ITIStartTime - Trial.ProbeStartTime;
            ONSETS(i,12) = Trial.ProbeStartTime;
            % NUMBER CORRECT
            if strcmp(Trial.NumberResponseAcc,'HT') || strcmp(Trial.NumberResponseAcc,'CR')
                if strcmp(Trial.NumType,'LowNEG')
                    DUR(i,7) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,7) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighNEG')
                    DUR(i,8)  = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,8) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'LowPOS')
                    DUR(i,9) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,9) = Trial.RetentionStartTime;
                elseif strcmp(Trial.NumType,'HighPOS')
                    DUR(i,10) = Trial.PostRetStartTime - Trial.RetentionStartTime;
                    ONSETS(i,10) = Trial.RetentionStartTime;
                end
            end
        end
    % Check for LETTER incorrect responses
    elseif strcmp(Trial.LetterResponseAcc,'CR')
    end
end
% 2 Letter
    
    % 6 Letter 
    
    % NUMBER CORRECT
    % Low Number
    
    % High Number
    
    


