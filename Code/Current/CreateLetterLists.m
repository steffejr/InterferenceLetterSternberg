function [LetLists] = CreateLetterLists(handles)
% Create list of letters for letter sternberg
% I am thinkiong that this should be modified so that it does not create a
% full structure containing all the diffewrent letter list lengths. It
% would be nice if this was a matrix of structures. So that index 1 = list
% length 1, index 3 = list length 3, et cetera.
% Create the full alphabet
LetRange = 65:90;
% Here is a list of letters to EXCLUDE
LetToExclude = handles.LetToExclude;%['AEIOUCPSVWXZ'];
%LetToInc = ['LCTRMJSDZVHK'];
% we will create a list of leters to INCLUDE
LetToInc = [];
for i = 1:length(LetRange)
    flag = 0;
    for j = 1:length(LetToExclude)
        if (LetRange(i) == double(LetToExclude(j)))
            flag = 1;
        end
    end
    if ~flag
        LetToInc = [LetToInc LetRange(i)];
    end
end
%char(LetToInc)

% Create list of One Letters
LetList1 = [];
LetList2 = [];
LetList3 = [];
LetList6 = [];

N = length(LetToInc);
NList = 3000; % Possible list length
LetLists = cell(1,NList);
for i = 1:NList
    % make random choices from the letters WITHOUT replacement
    R1 = randperm(N);
    R1 = R1(1);
    R2 = randperm(N);
    R2 = R2(1:2);
    R3 = randperm(N);
    R3 = R3(1:3);
    R6 = randperm(N);
    R6 = R6(1:6);
    
    LetList1 = [char(LetToInc(R1))];
    LetList2 = [char(LetToInc(R2))];
    LetList3 = [char(LetToInc(R3))];
    LetList6 = [char(LetToInc(R6))];
    [LetList1Pos LetList1Neg] = subfnLetLstProbes(LetList1, LetToInc);
    [LetList2Pos LetList2Neg] = subfnLetLstProbes(LetList2, LetToInc);
    [LetList3Pos LetList3Neg] = subfnLetLstProbes(LetList3, LetToInc);
    [LetList6Pos LetList6Neg] = subfnLetLstProbes(LetList6, LetToInc);

    
    
    LetLists{i}(1).LetList = LetList1;
    LetLists{i}(1).LetListPOS = LetList1Pos;
    LetLists{i}(1).LetListNEG = LetList1Neg;
    LetLists{i}(2).LetList = LetList2;
    LetLists{i}(2).LetListPOS = LetList2Pos;
    LetLists{i}(2).LetListNEG = LetList2Neg;
    LetLists{i}(3).LetList = LetList3;
    LetLists{i}(3).LetListPOS = LetList3Pos;
    LetLists{i}(3).LetListNEG = LetList3Neg;
    LetLists{i}(6).LetList = LetList6;
    LetLists{i}(6).LetListPOS = LetList6Pos;
    LetLists{i}(6).LetListNEG = LetList6Neg;
end


function [LetListPos LetListNeg] = subfnLetLstProbes(LetList, LetToInc)

% POSITIVE Probe
tempLetToInc = LetList;
PosPro = lower(char(tempLetToInc(ceil(rand(1)*length(tempLetToInc)))));
LetListPos = [PosPro];
% NEGATIVE Probe
% Create new list of letters that DO not contain the study set
tempLetToExc = [LetList];
tempLetToInc = [];
for k = 1:length(LetToInc)
    flag = 0;
    for j = 1:length(tempLetToExc)
        
        if (LetToInc(k) == double(tempLetToExc(j)))
            flag = 1;
        end
    end
    if ~flag
        tempLetToInc = [tempLetToInc LetToInc(k)];
    end
end
% Select a random letter from this list as the probe
NegPro = lower(char(tempLetToInc(ceil(rand(1)*length(tempLetToInc)))));
LetListNeg = [NegPro];


