function [OutputHeader Output cOutputHeader cOutput] = subfnLetterSternbergCalculateDL_v3(Data);
% All calculataions are
% taken from the various Excel spreadsheets on the fmri drive.
%
%   filename: subRSMFCalculateDL.m
%   written by: Jason Steffener
%   date: October 6, 2008
%%
LoadLevels = [1 3 6]; 
NEventLoad = length(LoadLevels);
% Number of Runs in data file
NRuns = size(Data.Run,2);
% Split up the reaction times into correct response and incorrect responses
% and split by positive and negative probe types

% RTAll RTCor RTInc RTPos RTNeg RTHT RTMS RTCR RTFA
RTFull = zeros(NRuns,NEventLoad, 9, 200); 
% The NEvents is just a place holder to 
% be more than all possible number of trials for each load level and run.
% % % % In case you just want to print out all event labels
% % % for j = 1:30
% % %     fprintf(1,'%d\t%s\t%s\n',j,Data.Run{3}.Event{j}.ResponseLabel,Data.Run{3}.Event{j}.Time);
% % % end
% HT MS CR FA TOPos TONeg PosOT NegOT
OutData = zeros(NRuns,NEventLoad, 8);
% cycle over runs
for i = 1:NRuns
    NEvents = size(Data.Run{i}.Event,2);
    % cycle over events
    for j = 1:NEvents
        CurrentEvent = Data.Run{i}.Event{j};
        % CORRECT TRIALS
        if length(strmatch(CurrentEvent.Label,'Correct'))
            CurrentProbeType = CurrentEvent.Tag(2);
            % This is slightly esoteric but it is done to convert the load
            % levels of 1,3,6 to 1,2,3
            CurrentLoad = floor(str2num(CurrentEvent.Tag(1))/3) + 1;
            switch CurrentProbeType
                case 'P' % Correct Positive Probe = Hit
                    OutData(i,CurrentLoad,[1 7]) =  OutData(i,CurrentLoad,[1 7]) + 1;
                    RTFull(i,CurrentLoad,[1 2 4 6],j) = RTFull(i,CurrentLoad,[1 2 4 6],j) + str2num(CurrentEvent.Time);
                case 'N' % Correct Negative Probe = Correct Rejection
                    OutData(i,CurrentLoad,[3 8]) =  OutData(i,CurrentLoad,[3 8]) + 1;
                    RTFull(i,CurrentLoad,[1 2 5 8],j) = RTFull(i,CurrentLoad,[1 2 5 8],j) + str2num(CurrentEvent.Time);
            end
        % INCORRECT TRIALS
        elseif length(strmatch(CurrentEvent.Label,'Incorrect'))
            CurrentProbeType = CurrentEvent.Tag(2);
            CurrentLoad = floor(str2num(CurrentEvent.Tag(1))/3) + 1;
            switch CurrentProbeType
                case 'P' % Incorrect Positive Probe = Miss
                    OutData(i,CurrentLoad,[2 7]) =  OutData(i,CurrentLoad,[2 7]) + 1;
                    RTFull(i,CurrentLoad,[1 3 4 7],j) = RTFull(i,CurrentLoad,[1 3 4 7],j) + str2num(CurrentEvent.Time);
                case 'N' % Incorrect Negative Probe = False Alarm
                    OutData(i,CurrentLoad,[4 8]) =  OutData(i,CurrentLoad,[4 8]) + 1;
                    RTFull(i,CurrentLoad,[1 3 5 9],j) = RTFull(i,CurrentLoad,[1 3 5 9],j) + str2num(CurrentEvent.Time);
            end
        % TIME OUT
        elseif length(strmatch(CurrentEvent.Label,'TimeOut'))
            CurrentProbeType = CurrentEvent.Tag(2);
            CurrentLoad = floor(str2num(CurrentEvent.Tag(1))/3) + 1;
            switch CurrentProbeType
                case 'P' % 
                    OutData(i,CurrentLoad,[5]) =  OutData(i,CurrentLoad,[5]) + 1;
                case 'N' % 
                    OutData(i,CurrentLoad,[6]) =  OutData(i,CurrentLoad,[6]) + 1;
            end
        end
    end
end
RTFull = RTFull./1000;
%%
Output = [];
%
HT = zeros(NRuns,NEventLoad);
CR = zeros(NRuns,NEventLoad);
MS = zeros(NRuns,NEventLoad);
FA = zeros(NRuns,NEventLoad);
%QR = zeros(NRuns,NEventLoad);
TOpos = zeros(NRuns,NEventLoad);
TOneg = zeros(NRuns,NEventLoad);
DL = zeros(NRuns,NEventLoad);
CL = zeros(NRuns,NEventLoad);
PosOT = zeros(NRuns,NEventLoad);
NegOT = zeros(NRuns,NEventLoad);
propHT = zeros(NRuns,NEventLoad);
propFA = zeros(NRuns,NEventLoad);
%MeanRT = (RT(:,:,1)./RT(:,:,2))';
% end change
TotalData = OutData;
RTOut = zeros(NRuns, NEventLoad, 9);
for i = 1:NRuns
    %% calculate the RT for each run and event type
    for j = 1:NEventLoad
        % convert the HT and FA to proportions of total on-time responses
        % these formulas are taken from the RSMF Group Statistics_total.xls
        % file found at: \fmri\RSMF\Imaging Data\RSMF Group Statistics
        %
        HT(i,j) = sum(TotalData(i,j,1));
        CR(i,j) = sum(TotalData(i,j,3));
        MS(i,j) = sum(TotalData(i,j,2));
        FA(i,j) = sum(TotalData(i,j,4));

%        QR(i,j) = sum(TotalData(i,j,length(Responses)+3));
        TOpos(i,j) = sum(TotalData(i,j,5));
        TOneg(i,j) = sum(TotalData(i,j,6));
        PosOT(i,j) = sum(TotalData(i,j,7));
        NegOT(i,j) = sum(TotalData(i,j,8));
%         proportionHT(j) = (HT(j)+0.5)/(PosOT(j)+1);
%         proportionFA(j) = 1-(CR(j)+0.5)/(NegOT(j)+1);
%         DL(i,j) = log10((proportionHT(j)*(1-proportionFA(j)))/((1-proportionHT(j))*proportionFA(j)));
        propHT(i,j) = (HT(i,j)+0.5)/(PosOT(i,j)+1);
        propFA(i,j) = 1-(CR(i,j)+0.5)/(NegOT(i,j)+1);
        DL(i,j) = log10((propHT(i,j)*(1-propFA(i,j)))/((1-propHT(i,j))*propFA(i,j)));
        CL(i,j) = 0.5*(log10(((1-propHT(i,j))*(1-propFA(i,j)))/(propHT(i,j)*propFA(i,j))));
        % Calculate the different Reaction Time Measures
        for k = 1:9
            if length(find(RTFull(i,j,k,:)))
                RTOut(i,j,k) = mean(squeeze(RTFull(i,j,k,find(RTFull(i,j,k,:)))));
            end
        end
    end
    % Output = LoadLevel CR HT NegOT PosOT propHT propFA dL cL TOpos TOneg
    % RTAll RTCor RTInc RTPos RTNeg RTCorPos RTIncPos RTCorNeg RTIncNeg
    Output(:, :, i) = [LoadLevels' HT(i,:)' MS(i,:)' CR(i,:)' FA(i,:)' PosOT(i,:)' NegOT(i,:)' propHT(i,:)' propFA(i,:)' DL(i,:)' CL(i,:)' TOpos(i,:)' TOneg(i,:)'...
    squeeze(RTOut(i,:,:))];
end





%% Collapse across RUNS and recalculate
TotalData = squeeze(sum(OutData,2));

[m n o p] = size(RTFull);
% Runs, measures, trials
% cRTFull = zeros(m,o,p);
% cRTFull = squeeze(cRTFull);
% % If there are more than one run
% if m > 1
%     cRTFull(:,:,1:200) = squeeze(RTFull(:,1,:,:));
%     cRTFull(:,:,201:400) = squeeze(RTFull(:,2,:,:));
%     cRTFull(:,:,401:600) = squeeze(RTFull(:,3,:,:));
% elseif m ==1
%     cRTFull(:,1:200) = squeeze(RTFull(:,1,:,:));
%     cRTFull(:,201:400) = squeeze(RTFull(:,2,:,:));
%     cRTFull(:,401:600) = squeeze(RTFull(:,3,:,:));
% end

%[squeeze(RTFull(:,1,:,:)) squeeze(RTFull(:,2,:,:))  squeeze(RTFull(:,3,:,:))];
%cOutput = [];
%
HT = zeros(NEventLoad,1);
CR = zeros(NEventLoad,1);
MS = zeros(NEventLoad,1);
FA = zeros(NEventLoad,1);
%QR = zeros(NRuns,NEventLoad);
TOpos = zeros(NEventLoad,1);
TOneg = zeros(NEventLoad,1);
DL = zeros(NEventLoad,1);
CL = zeros(NEventLoad,1);
PosOT = zeros(NEventLoad,1);
NegOT = zeros(NEventLoad,1);
propHT = zeros(NEventLoad,1);
propFA = zeros(NEventLoad,1);
%MeanRT = (RT(:,:,1)./RT(:,:,2))';
% end change
% COLLAPSE ACROSS 
cRTOut = zeros(NEventLoad, 27);
for j = 1:NEventLoad
    % convert the HT and FA to proportions of total on-time responses
    % these formulas are taken from the RSMF Group Statistics_total.xls
    % file found at: \fmri\RSMF\Imaging Data\RSMF Group Statistics
    %
    HT(j) = sum(TotalData(j,1));
    CR(j) = sum(TotalData(j,3));
    MS(j) = sum(TotalData(j,2));
    FA(j) = sum(TotalData(j,4));

    %        QR(i,j) = sum(TotalData(i,j,length(Responses)+3));
    TOpos(j) = sum(TotalData(j,5));
    TOneg(j) = sum(TotalData(j,6));
    PosOT(j) = sum(TotalData(j,7));
    NegOT(j) = sum(TotalData(j,8));
    %         proportionHT(j) = (HT(j)+0.5)/(PosOT(j)+1);
    %         proportionFA(j) = 1-(CR(j)+0.5)/(NegOT(j)+1);
    %         DL(i,j) = log10((proportionHT(j)*(1-proportionFA(j)))/((1-proportionHT(j))*proportionFA(j)));
    propHT(j) = (HT(j)+0.5)/(PosOT(j)+1);
    propFA(j) = 1-(CR(j)+0.5)/(NegOT(j)+1);
    DL(j) = log10((propHT(j)*(1-propFA(j)))/((1-propHT(j))*propFA(j)));
    CL(j) = 0.5*(log10(((1-propHT(j))*(1-propFA(j)))/(propHT(j)*propFA(j))));
    % Calculate the MEAN different Reaction Time Measures

    % RTAll RTCor RTInc RTPos RTNeg RTHT RTMS RTCR RTFA

   
     % Calculate the MEAN different Reaction Time Measures
    for k = 1:9
        %if length(find(cRTFull(j,k,:)))
            % FIND THE RTs FOR EACH LOAD LEVEL FOR THIS MEASURE
            % (Runs, Load, Measure, trials)
            temp = squeeze(RTFull(1,j,k,:));
            Run1 = temp(find(temp));
            temp = squeeze(RTFull(2,j,k,:));
            Run2 = temp(find(temp));
            temp = squeeze(RTFull(3,j,k,:));
            Run3 = temp(find(temp));
            AllRuns = [Run1; Run2; Run3];
            cRTOut(j,k) = median(AllRuns);
            cRTOut(j,k+9) = mean(AllRuns);
            cRTOut(j,k+18) = std(AllRuns);
    end
end
cOutput = [ HT MS CR FA PosOT NegOT propHT propFA DL CL TOpos TOneg...
    cRTOut];
%% Create Header
% [PathName FileName] = fileparts(InputFile(p,:));
% attempt to pull out subject number
%     UnderScores = strfind(FileName, '_');
%     if length(UnderScores) == 2
%         SubNum = FileName(UnderScores(1)+1:UnderScores(2)-1);
%     else
%         SubNum = FileName;
%     end
%     for i = 1:NEventLoad
%         fprintf(fid,'%s,%s,%d,%d,%d,',SubNum,probdur{i},CR(i),HT(i),NegOT(i));
%         fprintf(fid,'%d,%0.4f,%0.4f,',PosOT(i),MeanOverRunRT(i),proportionHT(i));
%         fprintf(fid,'%0.4f,%0.4f,%0.4f',proportionFA(i),DL(i),CL(i));
%         fprintf(fid,'\n');
%     end
%%
OutputHeader = {'Load' 'HT' 'MS' 'CR' 'FA' 'PosOT' 'NegOT' 'propHT' 'propFA' 'DL' 'CL' 'TOpos' 'TOneg' 'RTall' ...
   'RTCor' 'RTInc' 'RTPos' 'RTNeg' 'RTHT' 'RTMS' 'RTCR' 'RTFA'};
cOutputHeader = {'HT' 'MS' 'CR' 'FA' 'PosOT' 'NegOT' 'propHT' 'propFA' 'DL' 'CL' 'TOpos' 'TOneg' 'medRTall' ...
   'medRTCor' 'medRTInc' 'medRTPos' 'medRTNeg' 'medRTHT' 'medRTMS' 'medRTCR' 'medRTFA' 'RTall' ...
   'RTCor' 'RTInc' 'RTPos' 'RTNeg' 'mnRTHT' 'mnRTMS' 'mnRTCR' 'mnRTFA' 'stdRTall' ...
   'stdRTCor' 'stdRTInc' 'stdRTPos' 'stdRTNeg' 'stdRTHT' 'stdRTMS' 'stdRTCR' 'stdRTFA'};
