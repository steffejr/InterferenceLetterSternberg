function [Trials Results] = subfnCorrectResponses_LetNum(EP)
% This checks "grades" each trial to see if correct or incorrect responses
% were made. It also creates a summary Results structure of accuracy and
% median response times.
if iscell(EP)
    Trials = [];
    Design = [];
    for j = 1:length(EP)
        Trials = [Trials; EP{j}.ExperimentParameters.Trials];
        Design = [Design; EP{j}.ExperimentParameters.Design];
    end
    Buttons = EP{1}.ExperimentParameters.Buttons;
elseif isstruct(EP)
    Trials = EP.Trials;
    Design = EP.Design;
    Buttons = EP.Buttons;
end

% Written by Jason Steffener
% December 2011
%
%
% Provide total results for the experimenter
% CALCULATE dL

Results = {};
LoadLevels = unique(Design(:,1));
for j = 1:length(LoadLevels)
    i = LoadLevels(j);
    Results{i}.Let_All_Acc = 0;
    Results{i}.Let_Pos_Acc = 0;
    Results{i}.Let_Neg_Acc = 0;
    Results{i}.Let_All_Acc_LowNum = 0;
    Results{i}.Let_Pos_Acc_LowNum = 0;
    Results{i}.Let_Neg_Acc_LowNum = 0;
    Results{i}.Let_All_Acc_HighNum = 0;
    Results{i}.Let_Pos_Acc_HighNum = 0;
    Results{i}.Let_Neg_Acc_HighNum = 0;
    
    Results{i}.Let_All_Cor_MedRT = [];
    Results{i}.Let_Pos_Cor_MedRT = [];
    Results{i}.Let_Neg_Cor_MedRT = [];
    Results{i}.Let_All_Cor_MedRT_LowNum = [];
    Results{i}.Let_Pos_Cor_MedRT_LowNum = [];
    Results{i}.Let_Neg_Cor_MedRT_LowNum = [];
    Results{i}.Let_All_Cor_MedRT_HighNum = [];
    Results{i}.Let_Pos_Cor_MedRT_HighNum = [];
    Results{i}.Let_Neg_Cor_MedRT_HighNum = [];

    Results{i}.Let_All_Inc_MedRT = [];
    Results{i}.Let_Pos_Inc_MedRT = [];
    Results{i}.Let_Neg_Inc_MedRT = [];
    Results{i}.Let_All_Inc_MedRT_LowNum = [];
    Results{i}.Let_Pos_Inc_MedRT_LowNum = [];
    Results{i}.Let_Neg_Inc_MedRT_LowNum = [];
    Results{i}.Let_All_Inc_MedRT_HighNum = [];
    Results{i}.Let_Pos_Inc_MedRT_HighNum = [];
    Results{i}.Let_Neg_Inc_MedRT_HighNum = [];
    
    Results{i}.Let_All_Count = 0;
    Results{i}.Let_Pos_Count = 0;
    Results{i}.Let_Neg_Count = 0;
    Results{i}.Let_All_Count_LowNum = 0;
    Results{i}.Let_Pos_Count_LowNum = 0;
    Results{i}.Let_Neg_Count_LowNum = 0;
    Results{i}.Let_All_Count_HighNum = 0;
    Results{i}.Let_Pos_Count_HighNum = 0;
    Results{i}.Let_Neg_Count_HighNum = 0;

    Results{i}.Let_All_propTO = 0;
    Results{i}.Let_Pos_propTO = 0;
    Results{i}.Let_Neg_propTO = 0;    
    Results{i}.Let_All_propTO_LowNum = 0;
    Results{i}.Let_Pos_propTO_LowNum = 0;
    Results{i}.Let_Neg_propTO_LowNum = 0;    
    Results{i}.Let_All_propTO_HighNum = 0;
    Results{i}.Let_Pos_propTO_HighNum = 0;
    Results{i}.Let_Neg_propTO_HighNum = 0;    

end
Results{99}.Num_Low_All_Acc = 0;
Results{99}.Num_Low_Pos_Acc = 0;
Results{99}.Num_Low_Neg_Acc = 0;
Results{99}.Num_High_All_Acc = 0;
Results{99}.Num_High_Pos_Acc = 0;
Results{99}.Num_High_Neg_Acc = 0;

Results{99}.Num_Low_All_Count = 0;
Results{99}.Num_Low_Pos_Count = 0;
Results{99}.Num_Low_Neg_Count = 0;
Results{99}.Num_High_All_Count = 0;
Results{99}.Num_High_Pos_Count = 0;
Results{99}.Num_High_Neg_Count = 0;

Results{99}.Num_Low_All_Cor_MedRT = [];
Results{99}.Num_Low_Pos_Cor_MedRT = [];
Results{99}.Num_Low_Neg_Cor_MedRT = [];
Results{99}.Num_Low_All_Inc_MedRT = [];
Results{99}.Num_Low_Pos_Inc_MedRT = [];
Results{99}.Num_Low_Neg_Inc_MedRT = [];

Results{99}.Num_High_All_Cor_MedRT = [];
Results{99}.Num_High_Pos_Cor_MedRT = [];
Results{99}.Num_High_Neg_Cor_MedRT = [];
Results{99}.Num_High_All_Inc_MedRT = [];
Results{99}.Num_High_Pos_Inc_MedRT = [];
Results{99}.Num_High_Neg_Inc_MedRT = []; 

Results{99}.Num_Low_All_propTO = 0;
Results{99}.Num_Low_Pos_propTO = 0;
Results{99}.Num_Low_Neg_propTO = 0;
Results{99}.Num_High_All_propTO = 0;
Results{99}.Num_High_Pos_propTO = 0;
Results{99}.Num_High_Neg_propTO = 0;

NTrials = length(Trials);
for trialIndex = 1:NTrials
    % LETTERS
    % Check the LAST button Press to see if is one of the buttons that were
    % considered possible.
    
    for j = 1:length(Trials{trialIndex}.LetterResponseButton)
        if ~isempty(Trials{trialIndex}.LetterResponseButton{j})
            ThisTrialLetterResponse = char(Trials{trialIndex}.LetterResponseButton{j}(1));
            % See if the button was Yes
            if isempty(strfind(ThisTrialLetterResponse,EP.RunConditions.MRITrigger))
                if (~isempty(strfind(char(Buttons.LetterYes),ThisTrialLetterResponse)))
                    Trials{trialIndex}.LetterResponseCode = 'Y';
                elseif ~isempty(strfind(char(Buttons.LetterNo),ThisTrialLetterResponse))
                    Trials{trialIndex}.LetterResponseCode = 'N';
                else
                    Trials{trialIndex}.LetterResponseCode = '?';
                end
            end
        else
            break;
        end
    end
    % find the index of the LAST response recorded for this trial
    tempLet = max(Trials{trialIndex}.LetterResponseTime>-99);
    % check for accuracy of LETTER responses
    % YES and POS   = hit
    if strcmp(Trials{trialIndex}.LetterResponseCode, 'Y') && Design(trialIndex,3)== 1
        Trials{trialIndex}.LetterResponseAcc = 'HT';
        index = str2num(Trials{trialIndex}.LetType(1));
        Results{index}.Let_All_Count = Results{index}.Let_All_Count + 1;
        Results{index}.Let_All_Acc = Results{index}.Let_All_Acc + 1;
        Results{index}.Let_Pos_Acc = Results{index}.Let_Pos_Acc + 1;
        Results{index}.Let_Pos_Count = Results{index}.Let_Pos_Count + 1;
        Results{index}.Let_All_Cor_MedRT(length(Results{index}.Let_All_Cor_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        Results{index}.Let_Pos_Cor_MedRT(length(Results{index}.Let_Pos_Cor_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{index}.Let_All_Count_LowNum = Results{index}.Let_All_Count_LowNum + 1;
            Results{index}.Let_All_Acc_LowNum = Results{index}.Let_All_Acc_LowNum + 1;
            Results{index}.Let_Pos_Acc_LowNum = Results{index}.Let_Pos_Acc_LowNum + 1;
            Results{index}.Let_Pos_Count_LowNum = Results{index}.Let_Pos_Count_LowNum + 1;
            Results{index}.Let_All_Cor_MedRT_LowNum(length(Results{index}.Let_All_Cor_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Pos_Cor_MedRT_LowNum(length(Results{index}.Let_Pos_Cor_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        elseif(~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{index}.Let_All_Count_HighNum = Results{index}.Let_All_Count_HighNum + 1;
            Results{index}.Let_All_Acc_HighNum = Results{index}.Let_All_Acc_HighNum + 1;
            Results{index}.Let_Pos_Acc_HighNum = Results{index}.Let_Pos_Acc_HighNum + 1;
            Results{index}.Let_Pos_Count_HighNum = Results{index}.Let_Pos_Count_HighNum + 1;
            Results{index}.Let_All_Cor_MedRT_HighNum(length(Results{index}.Let_All_Cor_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Pos_Cor_MedRT_HighNum(length(Results{index}.Let_Pos_Cor_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        end
        % YES and NEG   = false alarm
    elseif strcmp(Trials{trialIndex}.LetterResponseCode, 'Y') && Design(trialIndex,3)== -1
        Trials{trialIndex}.LetterResponseAcc = 'FA';
        index = str2num(Trials{trialIndex}.LetType(1));
        Results{index}.Let_All_Count = Results{index}.Let_All_Count + 1;
        Results{index}.Let_Neg_Count = Results{index}.Let_Neg_Count + 1;
        Results{index}.Let_All_Inc_MedRT(length(Results{index}.Let_All_Inc_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        Results{index}.Let_Neg_Inc_MedRT(length(Results{index}.Let_Neg_Inc_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{index}.Let_All_Count_LowNum = Results{index}.Let_All_Count_LowNum + 1;
            Results{index}.Let_Neg_Count_LowNum = Results{index}.Let_Neg_Count_LowNum + 1;
            Results{index}.Let_All_Inc_MedRT_LowNum(length(Results{index}.Let_All_Inc_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Neg_Inc_MedRT_LowNum(length(Results{index}.Let_Neg_Inc_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        elseif(~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{index}.Let_All_Count_HighNum = Results{index}.Let_All_Count_HighNum + 1;
            Results{index}.Let_Neg_Count_HighNum = Results{index}.Let_Neg_Count_HighNum + 1;
            Results{index}.Let_All_Inc_MedRT_HighNum(length(Results{index}.Let_All_Inc_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Neg_Inc_MedRT_HighNum(length(Results{index}.Let_Neg_Inc_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        end
        % NO and NEG    = correct rejection
    elseif strcmp(Trials{trialIndex}.LetterResponseCode, 'N') && Design(trialIndex,3)== -1
        Trials{trialIndex}.LetterResponseAcc = 'CR';
        index = str2num(Trials{trialIndex}.LetType(1));
        Results{index}.Let_All_Count = Results{index}.Let_All_Count + 1;
        Results{index}.Let_All_Acc = Results{index}.Let_All_Acc + 1;
        Results{index}.Let_Neg_Acc = Results{index}.Let_Neg_Acc + 1;
        Results{index}.Let_Neg_Count = Results{index}.Let_Neg_Count + 1;
        Results{index}.Let_All_Cor_MedRT(length(Results{index}.Let_All_Cor_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        Results{index}.Let_Neg_Cor_MedRT(length(Results{index}.Let_Neg_Cor_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{index}.Let_All_Count_LowNum = Results{index}.Let_All_Count_LowNum + 1;
            Results{index}.Let_All_Acc_LowNum = Results{index}.Let_All_Acc_LowNum + 1;
            Results{index}.Let_Neg_Acc_LowNum = Results{index}.Let_Neg_Acc_LowNum + 1;
            Results{index}.Let_Neg_Count_LowNum = Results{index}.Let_Neg_Count_LowNum + 1;
            Results{index}.Let_All_Cor_MedRT_LowNum(length(Results{index}.Let_All_Cor_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Neg_Cor_MedRT_LowNum(length(Results{index}.Let_Neg_Cor_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        elseif(~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{index}.Let_All_Count_HighNum = Results{index}.Let_All_Count_HighNum + 1;
            Results{index}.Let_All_Acc_HighNum = Results{index}.Let_All_Acc_HighNum + 1;
            Results{index}.Let_Neg_Acc_HighNum = Results{index}.Let_Neg_Acc_HighNum + 1;
            Results{index}.Let_Neg_Count_HighNum = Results{index}.Let_Neg_Count_HighNum + 1;
            Results{index}.Let_All_Cor_MedRT_HighNum(length(Results{index}.Let_All_Cor_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Neg_Cor_MedRT_HighNum(length(Results{index}.Let_Neg_Cor_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        end
        % NO and POS    = miss
    elseif strcmp(Trials{trialIndex}.LetterResponseCode, 'N') && Design(trialIndex,3)== 1
        Trials{trialIndex}.LetterResponseAcc = 'MS';
        index = str2num(Trials{trialIndex}.LetType(1));
        Results{index}.Let_All_Count = Results{index}.Let_All_Count + 1;
        Results{index}.Let_Pos_Count = Results{index}.Let_Pos_Count + 1;
        Results{index}.Let_All_Inc_MedRT(length(Results{index}.Let_All_Inc_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        Results{index}.Let_Pos_Inc_MedRT(length(Results{index}.Let_Pos_Inc_MedRT)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{index}.Let_All_Count_LowNum = Results{index}.Let_All_Count_LowNum + 1;
            Results{index}.Let_Pos_Count_LowNum = Results{index}.Let_Pos_Count_LowNum + 1;
            Results{index}.Let_All_Inc_MedRT_LowNum(length(Results{index}.Let_All_Inc_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Pos_Inc_MedRT_LowNum(length(Results{index}.Let_Pos_Inc_MedRT_LowNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        elseif(~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{index}.Let_All_Count_HighNum = Results{index}.Let_All_Count_HighNum + 1;
            Results{index}.Let_Pos_Count_HighNum = Results{index}.Let_Pos_Count_HighNum + 1;
            Results{index}.Let_All_Inc_MedRT_HighNum(length(Results{index}.Let_All_Inc_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
            Results{index}.Let_Pos_Inc_MedRT_HighNum(length(Results{index}.Let_Pos_Inc_MedRT_HighNum)+1) = Trials{trialIndex}.LetterResponseTime(tempLet);
        end
        % Time Out and POS
    elseif Trials{trialIndex}.LetterResponseTime(1) == -99 && Design(trialIndex,3)== 1
        Trials{trialIndex}.LetterResponseAcc = 'TO';
        index = str2num(Trials{trialIndex}.LetType(1));
        Results{index}.Let_All_propTO = Results{index}.Let_All_propTO + 1;
        Results{index}.Let_Pos_propTO = Results{index}.Let_Pos_propTO + 1;       
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{index}.Let_All_propTO_LowNum = Results{index}.Let_All_propTO_LowNum + 1;
            Results{index}.Let_Pos_propTO_LowNum = Results{index}.Let_Pos_propTO_LowNum + 1;
        elseif(~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{index}.Let_All_propTO_HighNum = Results{index}.Let_All_propTO_HighNum + 1;
            Results{index}.Let_Pos_propTO_HighNum = Results{index}.Let_Pos_propTO_HighNum + 1;
        end
        % Time Out and POS
    elseif Trials{trialIndex}.LetterResponseTime(1) == -99 && Design(trialIndex,3)== -1
        Trials{trialIndex}.LetterResponseAcc = 'TO';
        index = str2num(Trials{trialIndex}.LetType(1));
        Results{index}.Let_All_propTO = Results{index}.Let_All_propTO + 1;
        Results{index}.Let_Neg_propTO = Results{index}.Let_Neg_propTO + 1;    
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{index}.Let_All_propTO_LowNum = Results{index}.Let_All_propTO_LowNum + 1;
            Results{index}.Let_Neg_propTO_LowNum = Results{index}.Let_Neg_propTO_LowNum + 1;
        elseif(~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{index}.Let_All_propTO_HighNum = Results{index}.Let_All_propTO_HighNum + 1;
            Results{index}.Let_Neg_propTO_HighNum = Results{index}.Let_Neg_propTO_HighNum + 1;
        end
    end
    
    tempNum = max(Trials{trialIndex}.NumberResponseTime>-99);
    % NUMBERS
    
    for j = 1:length(Trials{trialIndex}.NumberResponseButton)
        
        if ~isempty(Trials{trialIndex}.NumberResponseButton{j})
            ThisTrialNumberResponse = char(Trials{trialIndex}.NumberResponseButton{j}(1));
            if isempty(strfind(ThisTrialNumberResponse,EP.RunConditions.MRITrigger))
                % See if the button was Yes
                if ~isempty(strfind(char(Buttons.NumberYes),ThisTrialNumberResponse))
                    Trials{trialIndex}.NumberResponseCode = 'Y';
                elseif ~isempty(strfind(char(Buttons.NumberNo),ThisTrialNumberResponse))
                    Trials{trialIndex}.NumberResponseCode = 'N';
                else
                    Trials{trialIndex}.NumberResponseCode = '?';
                end
            end
        else
            break;
        end
    end
    
    % check for accuracy of NUMBER responses
    % YES and POS   = hit
    if strcmp(Trials{trialIndex}.NumberResponseCode, 'Y') && Design(trialIndex,4)== 1
        Trials{trialIndex}.NumberResponseAcc = 'HT';
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{99}.Num_Low_All_Count = Results{99}.Num_Low_All_Count + 1;
            Results{99}.Num_Low_All_Acc = Results{99}.Num_Low_All_Acc + 1;
            Results{99}.Num_Low_Pos_Count = Results{99}.Num_Low_Pos_Count + 1;
            Results{99}.Num_Low_Pos_Acc = Results{99}.Num_Low_Pos_Acc + 1;
            Results{99}.Num_Low_All_Cor_MedRT(length(Results{99}.Num_Low_All_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_Low_Pos_Cor_MedRT(length(Results{99}.Num_Low_Pos_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
        elseif (~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{99}.Num_High_All_Count = Results{99}.Num_High_All_Count + 1;
            Results{99}.Num_High_All_Acc = Results{99}.Num_High_All_Acc + 1;
            Results{99}.Num_High_Pos_Count = Results{99}.Num_High_Pos_Count + 1;
            Results{99}.Num_High_Pos_Acc = Results{99}.Num_High_Pos_Acc + 1;
            Results{99}.Num_High_All_Cor_MedRT(length(Results{99}.Num_High_All_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_High_Pos_Cor_MedRT(length(Results{99}.Num_High_Pos_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
        end
        % YES and NEG   = false alarm
    elseif strcmp(Trials{trialIndex}.NumberResponseCode, 'Y') && Design(trialIndex,4)== -1
        Trials{trialIndex}.NumberResponseAcc = 'FA';
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{99}.Num_Low_All_Count = Results{99}.Num_Low_All_Count + 1;
            Results{99}.Num_Low_Neg_Count = Results{99}.Num_Low_Neg_Count + 1;
            Results{99}.Num_Low_All_Inc_MedRT(length(Results{99}.Num_Low_All_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_Low_Neg_Inc_MedRT(length(Results{99}.Num_Low_Neg_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
        elseif (~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{99}.Num_High_All_Count = Results{99}.Num_High_All_Count + 1;
            Results{99}.Num_High_Neg_Count = Results{99}.Num_High_Neg_Count + 1;
            Results{99}.Num_High_All_Inc_MedRT(length(Results{99}.Num_High_All_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_High_Neg_Inc_MedRT(length(Results{99}.Num_High_Neg_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
        end
        % NO and NEG    = correct rejection
    elseif strcmp(Trials{trialIndex}.NumberResponseCode, 'N') && Design(trialIndex,4)== -1
        Trials{trialIndex}.NumberResponseAcc = 'CR';
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{99}.Num_Low_All_Count = Results{99}.Num_Low_All_Count + 1;
            Results{99}.Num_Low_All_Acc = Results{99}.Num_Low_All_Acc + 1;
            Results{99}.Num_Low_Neg_Count = Results{99}.Num_Low_Neg_Count + 1;
            Results{99}.Num_Low_Neg_Acc = Results{99}.Num_Low_Neg_Acc + 1;
            Results{99}.Num_Low_All_Cor_MedRT(length(Results{99}.Num_Low_All_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_Low_Neg_Cor_MedRT(length(Results{99}.Num_Low_Neg_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
        elseif (~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{99}.Num_High_All_Count = Results{99}.Num_High_All_Count + 1;
            Results{99}.Num_High_All_Acc = Results{99}.Num_High_All_Acc + 1;
            Results{99}.Num_High_Neg_Count = Results{99}.Num_High_Neg_Count + 1;
            Results{99}.Num_High_Neg_Acc = Results{99}.Num_High_Neg_Acc + 1;
            Results{99}.Num_High_All_Cor_MedRT(length(Results{99}.Num_High_All_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_High_Neg_Cor_MedRT(length(Results{99}.Num_High_Neg_Cor_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);        end
        % NO and POS    = miss
    elseif strcmp(Trials{trialIndex}.NumberResponseCode, 'N') && Design(trialIndex,4)== 1
        Trials{trialIndex}.NumberResponseAcc = 'MS';
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{99}.Num_Low_All_Count = Results{99}.Num_Low_All_Count + 1;
            Results{99}.Num_Low_Pos_Count = Results{99}.Num_Low_Pos_Count + 1;
            Results{99}.Num_Low_All_Inc_MedRT(length(Results{99}.Num_Low_All_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_Low_Pos_Inc_MedRT(length(Results{99}.Num_Low_Pos_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
        elseif (~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{99}.Num_High_All_Count = Results{99}.Num_High_All_Count + 1;
            Results{99}.Num_High_Pos_Count = Results{99}.Num_High_Pos_Count + 1;
            Results{99}.Num_High_All_Inc_MedRT(length(Results{99}.Num_High_All_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
            Results{99}.Num_High_Pos_Inc_MedRT(length(Results{99}.Num_High_Pos_Inc_MedRT)+1) = Trials{trialIndex}.NumberResponseTime(tempNum);
        end
        % Time Out And POS
    elseif Trials{trialIndex}.NumberResponseTime(1) == -99 && Design(trialIndex,4)== 1
        Trials{trialIndex}.NumberResponseAcc = 'TO';
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{99}.Num_Low_All_propTO = Results{99}.Num_Low_All_propTO + 1;
            Results{99}.Num_Low_Pos_propTO = Results{99}.Num_Low_Pos_propTO + 1;
        end
        if (~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{99}.Num_High_All_propTO = Results{99}.Num_High_All_propTO  + 1;
            Results{99}.Num_High_Pos_propTO = Results{99}.Num_High_Pos_propTO + 1;
        end
        % Time Out and Neg
    elseif Trials{trialIndex}.NumberResponseTime(1) == -99 && Design(trialIndex,4)== -1
        Trials{trialIndex}.NumberResponseAcc = 'TO';
        if (~isempty(strfind(Trials{trialIndex}.NumType,'Low')))
            Results{99}.Num_Low_All_propTO = Results{99}.Num_Low_All_propTO + 1;
            Results{99}.Num_Low_Neg_propTO = Results{99}.Num_Low_Neg_propTO + 1;
        end
        if (~isempty(strfind(Trials{trialIndex}.NumType,'High')))
            Results{99}.Num_High_All_propTO = Results{99}.Num_High_All_propTO + 1;
            Results{99}.Num_High_Neg_propTO = Results{99}.Num_High_Neg_propTO + 1;
        end
    end
end
% Calculate percentage accuracy
for k = 1:length(LoadLevels)
    j = LoadLevels(k);    
    Results{j}.Let_All_Acc = Results{j}.Let_All_Acc/Results{j}.Let_All_Count;
    Results{j}.Let_Pos_Acc = Results{j}.Let_Pos_Acc/Results{j}.Let_Pos_Count;
    Results{j}.Let_Neg_Acc = Results{j}.Let_Neg_Acc/Results{j}.Let_Neg_Count;
    Results{j}.Let_All_Cor_MedRT = median(Results{j}.Let_All_Cor_MedRT);
    Results{j}.Let_Pos_Cor_MedRT = median(Results{j}.Let_Pos_Cor_MedRT);
    Results{j}.Let_Neg_Cor_MedRT = median(Results{j}.Let_Neg_Cor_MedRT);
    Results{j}.Let_All_Inc_MedRT = median(Results{j}.Let_All_Inc_MedRT);
    Results{j}.Let_Pos_Inc_MedRT = median(Results{j}.Let_Pos_Inc_MedRT);
    Results{j}.Let_Neg_Inc_MedRT = median(Results{j}.Let_Neg_Inc_MedRT);
    Results{j}.Let_All_TO_Count = Results{j}.Let_All_propTO;
    Results{j}.Let_Pos_TO_Count = Results{j}.Let_Pos_propTO;
    Results{j}.Let_Neg_TO_Count = Results{j}.Let_Neg_propTO;
    Results{j}.Let_All_propTO = Results{j}.Let_All_propTO/(Results{j}.Let_All_TO_Count + Results{j}.Let_All_Count);
    Results{j}.Let_Pos_propTO = Results{j}.Let_Pos_propTO/(Results{j}.Let_Pos_TO_Count + Results{j}.Let_Pos_Count);
    Results{j}.Let_Neg_propTO = Results{j}.Let_Neg_propTO/(Results{j}.Let_Neg_TO_Count + Results{j}.Let_Neg_Count);

    Results{j}.Let_All_Acc_LowNum = Results{j}.Let_All_Acc_LowNum/Results{j}.Let_All_Count_LowNum;
    Results{j}.Let_Pos_Acc_LowNum = Results{j}.Let_Pos_Acc_LowNum/Results{j}.Let_Pos_Count_LowNum;
    Results{j}.Let_Neg_Acc_LowNum = Results{j}.Let_Neg_Acc_LowNum/Results{j}.Let_Neg_Count_LowNum;
    Results{j}.Let_All_Cor_MedRT_LowNum = median(Results{j}.Let_All_Cor_MedRT_LowNum);
    Results{j}.Let_Pos_Cor_MedRT_LowNum = median(Results{j}.Let_Pos_Cor_MedRT_LowNum);
    Results{j}.Let_Neg_Cor_MedRT_LowNum = median(Results{j}.Let_Neg_Cor_MedRT_LowNum);
    Results{j}.Let_All_Inc_MedRT_LowNum = median(Results{j}.Let_All_Inc_MedRT_LowNum);
    Results{j}.Let_Pos_Inc_MedRT_LowNum = median(Results{j}.Let_Pos_Inc_MedRT_LowNum);
    Results{j}.Let_Neg_Inc_MedRT_LowNum = median(Results{j}.Let_Neg_Inc_MedRT_LowNum);
    Results{j}.Let_All_TO_Count_LowNum = Results{j}.Let_All_propTO_LowNum;
    Results{j}.Let_Pos_TO_Count_LowNum = Results{j}.Let_Pos_propTO_LowNum;
    Results{j}.Let_Neg_TO_Count_LowNum = Results{j}.Let_Neg_propTO_LowNum;
    Results{j}.Let_All_propTO_LowNum = Results{j}.Let_All_propTO_LowNum/(Results{j}.Let_All_TO_Count_LowNum + Results{j}.Let_All_Count_LowNum);
    Results{j}.Let_Pos_propTO_LowNum = Results{j}.Let_Pos_propTO_LowNum/(Results{j}.Let_Pos_TO_Count_LowNum + Results{j}.Let_Pos_Count_LowNum);
    Results{j}.Let_Neg_propTO_LowNum = Results{j}.Let_Neg_propTO_LowNum/(Results{j}.Let_Neg_TO_Count_LowNum + Results{j}.Let_Neg_Count_LowNum);

    Results{j}.Let_All_Acc_HighNum = Results{j}.Let_All_Acc_HighNum/Results{j}.Let_All_Count_HighNum;
    Results{j}.Let_Pos_Acc_HighNum = Results{j}.Let_Pos_Acc_HighNum/Results{j}.Let_Pos_Count_HighNum;
    Results{j}.Let_Neg_Acc_HighNum = Results{j}.Let_Neg_Acc_HighNum/Results{j}.Let_Neg_Count_HighNum;
    Results{j}.Let_All_Cor_MedRT_HighNum = median(Results{j}.Let_All_Cor_MedRT_HighNum);
    Results{j}.Let_Pos_Cor_MedRT_HighNum = median(Results{j}.Let_Pos_Cor_MedRT_HighNum);
    Results{j}.Let_Neg_Cor_MedRT_HighNum = median(Results{j}.Let_Neg_Cor_MedRT_HighNum);
    Results{j}.Let_All_Inc_MedRT_HighNum = median(Results{j}.Let_All_Inc_MedRT_HighNum);
    Results{j}.Let_Pos_Inc_MedRT_HighNum = median(Results{j}.Let_Pos_Inc_MedRT_HighNum);
    Results{j}.Let_Neg_Inc_MedRT_HighNum = median(Results{j}.Let_Neg_Inc_MedRT_HighNum);
    Results{j}.Let_All_TO_Count_HighNum = Results{j}.Let_All_propTO_HighNum;
    Results{j}.Let_Pos_TO_Count_HighNum = Results{j}.Let_Pos_propTO_HighNum;
    Results{j}.Let_Neg_TO_Count_HighNum = Results{j}.Let_Neg_propTO_HighNum;
    Results{j}.Let_All_propTO_HighNum = Results{j}.Let_All_propTO_HighNum/(Results{j}.Let_All_TO_Count_HighNum + Results{j}.Let_All_Count_HighNum);
    Results{j}.Let_Pos_propTO_HighNum = Results{j}.Let_Pos_propTO_HighNum/(Results{j}.Let_Pos_TO_Count_HighNum + Results{j}.Let_Pos_Count_HighNum);
    Results{j}.Let_Neg_propTO_HighNum = Results{j}.Let_Neg_propTO_HighNum/(Results{j}.Let_Neg_TO_Count_HighNum + Results{j}.Let_Neg_Count_HighNum);
    
    Results{j}.propHT = (Results{j}.Let_Pos_Count*Results{j}.Let_Pos_Acc + 0.5) / ((length(Trials)/length(LoadLevels)/2 - Results{j}.Let_Pos_TO_Count)+1);
    Results{j}.propHT_LowNum = (Results{j}.Let_Pos_Count_LowNum*Results{j}.Let_Pos_Acc_LowNum + 0.5) / ((length(Trials)/length(LoadLevels)/4 - Results{j}.Let_Pos_TO_Count_LowNum)+1);
    Results{j}.propHT_HighNum = (Results{j}.Let_Pos_Count_HighNum*Results{j}.Let_Pos_Acc_HighNum + 0.5) / ((length(Trials)/length(LoadLevels)/4 - Results{j}.Let_Pos_TO_Count_HighNum)+1);
    
    Results{j}.propFA = 1 - (Results{j}.Let_Neg_Count*Results{j}.Let_Neg_Acc + 0.5) / ((length(Trials)/length(LoadLevels)/2 - Results{j}.Let_Neg_TO_Count)+1);
    Results{j}.propFA_LowNum = 1 - (Results{j}.Let_Neg_Count_LowNum*Results{j}.Let_Neg_Acc_LowNum + 0.5) / ((length(Trials)/length(LoadLevels)/4 - Results{j}.Let_Neg_TO_Count_LowNum)+1);
    Results{j}.propFA_HighNum = 1 - (Results{j}.Let_Neg_Count_HighNum*Results{j}.Let_Neg_Acc_HighNum + 0.5) / ((length(Trials)/length(LoadLevels)/4 - Results{j}.Let_Neg_TO_Count_HighNum)+1);
    
    Results{j}.dL = log10((Results{j}.propHT*(1-Results{j}.propFA))/((1-Results{j}.propHT)*Results{j}.propFA));
    Results{j}.dL_LowNum = log10((Results{j}.propHT_LowNum*(1-Results{j}.propFA_LowNum))/((1-Results{j}.propHT_LowNum)*Results{j}.propFA_LowNum));
    Results{j}.dL_HighNum = log10((Results{j}.propHT_HighNum*(1-Results{j}.propFA_HighNum))/((1-Results{j}.propHT_HighNum)*Results{j}.propFA_HighNum));
    
    Results{j}.cL = 0.5*log10((1-Results{j}.propHT*(1-Results{j}.propFA))/(Results{j}.propHT*Results{j}.propFA));
    Results{j}.cL_LowNum = 0.5*log10((1-Results{j}.propHT_LowNum*(1-Results{j}.propFA_LowNum))/(Results{j}.propHT_LowNum*Results{j}.propFA_LowNum));
    Results{j}.cL_HighNum = 0.5*log10((1-Results{j}.propHT_HighNum*(1-Results{j}.propFA_HighNum))/(Results{j}.propHT_HighNum*Results{j}.propFA_HighNum));

end
%% Calculate dL
    %    propHT(i,j) = (HT(i,j)+0.5)/(PosOT(i,j)+1);
    %         propFA(i,j) = 1-(CR(i,j)+0.5)/(NegOT(i,j)+1);
    %                  DL(i,j) = log10((propHT(i,j)*(1-propFA(i,j)))/((1-propHT(i,j))*propFA(i,j)));
    %         CL(i,j) = 0.5*(log10(((1-propHT(i,j))*(1-propFA(i,j)))/(propHT(i,j)*propFA(i,j))));

Results{99}.Num_Low_All_Acc = Results{99}.Num_Low_All_Acc/Results{99}.Num_Low_All_Count;
Results{99}.Num_Low_Pos_Acc = Results{99}.Num_Low_Pos_Acc/Results{99}.Num_Low_Pos_Count;
Results{99}.Num_Low_Neg_Acc = Results{99}.Num_Low_Neg_Acc/Results{99}.Num_Low_Neg_Count;
Results{99}.Num_High_All_Acc = Results{99}.Num_High_All_Acc/Results{99}.Num_High_All_Count;
Results{99}.Num_High_Pos_Acc = Results{99}.Num_High_Pos_Acc/Results{99}.Num_High_Pos_Count;
Results{99}.Num_High_Neg_Acc = Results{99}.Num_High_Neg_Acc/Results{99}.Num_High_Neg_Count;

Results{99}.Num_Low_All_Cor_MedRT = median(Results{99}.Num_Low_All_Cor_MedRT);
Results{99}.Num_Low_Pos_Cor_MedRT = median(Results{99}.Num_Low_Pos_Cor_MedRT);
Results{99}.Num_Low_Neg_Cor_MedRT = median(Results{99}.Num_Low_Neg_Cor_MedRT);
Results{99}.Num_High_All_Cor_MedRT = median(Results{99}.Num_High_All_Cor_MedRT);
Results{99}.Num_High_Pos_Cor_MedRT = median(Results{99}.Num_High_Pos_Cor_MedRT);
Results{99}.Num_High_Neg_Cor_MedRT = median(Results{99}.Num_High_Neg_Cor_MedRT);

Results{99}.Num_Low_All_Inc_MedRT = median(Results{99}.Num_Low_All_Inc_MedRT);
Results{99}.Num_Low_Pos_Inc_MedRT = median(Results{99}.Num_Low_Pos_Inc_MedRT);
Results{99}.Num_Low_Neg_Inc_MedRT = median(Results{99}.Num_Low_Neg_Inc_MedRT);
Results{99}.Num_High_All_Inc_MedRT = median(Results{99}.Num_High_All_Inc_MedRT);
Results{99}.Num_High_Pos_Inc_MedRT = median(Results{99}.Num_High_Pos_Inc_MedRT);
Results{99}.Num_High_Neg_Inc_MedRT = median(Results{99}.Num_High_Neg_Inc_MedRT);


Results{99}.Num_Low_All_TO_Count = Results{99}.Num_Low_All_propTO;
Results{99}.Num_Low_Pos_TO_Count = Results{99}.Num_Low_Pos_propTO;
Results{99}.Num_Low_Neg_TO_Count = Results{99}.Num_Low_Neg_propTO;
Results{99}.Num_High_All_TO_Count = Results{99}.Num_High_All_propTO;
Results{99}.Num_High_Pos_TO_Count = Results{99}.Num_High_Pos_propTO;
Results{99}.Num_High_Neg_TO_Count = Results{99}.Num_High_Neg_propTO;

Results{99}.Num_Low_All_propTO = Results{99}.Num_Low_All_propTO/(Results{99}.Num_Low_All_Count + Results{99}.Num_Low_All_TO_Count);
Results{99}.Num_Low_Pos_propTO = Results{99}.Num_Low_Pos_propTO/(Results{99}.Num_Low_Pos_Count + Results{99}.Num_Low_Pos_TO_Count);
Results{99}.Num_Low_Neg_propTO = Results{99}.Num_Low_Neg_propTO/(Results{99}.Num_Low_Neg_Count + Results{99}.Num_Low_Neg_TO_Count);
Results{99}.Num_High_All_propTO = Results{99}.Num_High_All_propTO/(Results{99}.Num_High_All_Count + Results{99}.Num_High_All_TO_Count);
Results{99}.Num_High_Pos_propTO = Results{99}.Num_High_Neg_propTO/(Results{99}.Num_High_Neg_Count + Results{99}.Num_High_Neg_TO_Count);
Results{99}.Num_High_Neg_propTO = Results{99}.Num_High_Neg_propTO/(Results{99}.Num_High_Neg_Count + Results{99}.Num_High_Neg_TO_Count);

