function [SumData Data] = FindAllData(subid)

% Calculate all final stats across participants
% Within subject factors
% NumLoad/NumValid/LetLoad
% Between subject factors
% age group
%
% Dependent Measures
% dL, cL, Acc, Throughput, median RT
%
% LetLoad   NumLoad     NumValid    LetValid 

%subid = '25';
Files = dir(['iLS_' num2str(subid) '*FB0*.mat']);
% Number of cells/number of trials/number of dependent measures
Data = zeros(16,500,2);
% HT/CR/MS/FA/TO = [1 2 3 4 5]

for j = 1:length(Files)
    load(Files(j).name);
    Design = ExperimentParameters.Design;
    for i = 1:length(Design)
            %Let2LetPOSNumLowNumPOS
        if sum(Design(i,:) == ([2 1 1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,1);
            %Let2LetPOSNumLowNumNEG
        elseif sum(Design(i,:) == ([2 1 1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,2);
            %Let2LetPOSNumHighNumPOS
        elseif sum(Design(i,:) == ([2 2 1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,3);
            %Let2LetPOSNumHighNumNEG
        elseif sum(Design(i,:) == ([2 2 1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,4);
            %Let2LetNEGNumLowNumPOS
        elseif sum(Design(i,:) == ([2 1 -1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,5);
            %Let2LetNEGNumLowNumNEG
        elseif sum(Design(i,:) == ([2 1 -1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,6);
            %Let2LetNEGNumHighNumPOS
        elseif sum(Design(i,:) == ([2 2 -1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,7);
            %Let2LetNEGNumHighNumNEG
        elseif sum(Design(i,:) == ([2 2 -1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,8);
            %Let6LetPOSNumLowNumPOS
        elseif sum(Design(i,:) == ([6 1 1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,9);
            %Let6LetPOSNumLowNumNEG
        elseif sum(Design(i,:) == ([6 1 1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,10);
            %Let6LetPOSNumHighNumPOS
        elseif sum(Design(i,:) == ([6 2 1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,11);
            %Let6LetPOSNumHighNumNEG
        elseif sum(Design(i,:) == ([6 2 1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,12);
            %Let6LetNEGNumLowNumPOS
        elseif sum(Design(i,:) == ([6 1 -1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,13);
            %Let6LetNEGNumLowNumNEG
        elseif sum(Design(i,:) == ([6 1 -1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,14);
            %Let6LetNEGNumHighNumPOS
        elseif sum(Design(i,:) == ([6 2 -1 1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,15);
            %Let6LetNEGNumHighNumNEG
        elseif sum(Design(i,:) == ([6 2 -1 -1])) == 4
            Data = subfnFillInData(Data, ExperimentParameters, i,16);
        end
    end
end
SumData = subfnCalculateSummaryStats(Data);

function SumData = subfnCalculateSummaryStats(Data)
SumData = zeros(16,2);
for i = 1:16
    SumData(i,1) = (length(find(Data(i,:,1)<3 & Data(i,:,1)>0))/...
        length(find(Data(i,:,1)<5 & Data(i,:,1)>0)));
    temp = Data(i,:,2);
    SumData(i,2) = median(temp(find(temp)>0));
end
%Collapse across NUMBER PROBE Type
for i = 1:8
    SumData(i+16,1) = (length(find(Data([i*2-1 i*2],:,1)<3 & Data([i*2-1 i*2],:,1)>0))/...
        length(find(Data([i*2-1 i*2],:,1)<5 & Data([i*2-1 i*2],:,1)>0)));
    temp = Data([i*2-1 i*2],:,2);
    SumData(i+16,2) = median(temp(find(temp)>0));
end
%Collapse across LETTER AND NUMBER PROBE Type
CollapseList = [1 2 5 6;
    3 4 7 8;
    9 10 13 14;
    11 12 15 16];
for i = 1:4
    SumData(i+24,1) = (length(find(Data(CollapseList(i,:),:,1)<3 & Data(CollapseList(i,:),:,1)>0))/...
        length(find(Data(CollapseList(i,:),:,1)<5 & Data(CollapseList(i,:),:,1)>0)));
    temp = Data(CollapseList(i,:),:,2);
    SumData(i+24,2) = median(temp(find(temp)>0));
end


function Data = subfnFillInData(Data, ExperimentParameters, i,col)
count1 = length(find(Data(col,:,1)))+1;
tempLet = max(ExperimentParameters.Trials{i}.LetterResponseTime>-99);
currentRT = ExperimentParameters.Trials{i}.LetterResponseTime(tempLet);
resp = ExperimentParameters.Trials{i}.LetterResponseAcc;
switch resp
    case 'HT'
        Data(col,count1,1) = 1;
        Data(col,count1,2) = currentRT;
    case 'CR'
        Data(col,count1,1) = 2;
        Data(col,count1,2) = currentRT;
    case 'MS'
        Data(col,count1,1) = 3;
        Data(col,count1,2) = currentRT;
    case 'FA'
        Data(col,count1,1) = 4;
        Data(col,count1,2) = currentRT;
    case 'TO'
        Data(col,count1,1) = 5;
end


