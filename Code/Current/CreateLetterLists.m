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
LetList4 = [];
LetList5 = [];
LetList6 = [];
LetList7 = [];
LetList8 = [];
LetList9 = [];

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
    R4 = randperm(N);
    R4 = R4(1:4);
    R5 = randperm(N);
    R5 = R5(1:5);
    R6 = randperm(N);
    R6 = R6(1:6);
    R7 = randperm(N);
    R7 = R7(1:7);
    R8 = randperm(N);
    R8 = R8(1:8);
    R9 = randperm(N);
    R9 = R9(1:9);
    
    LetList1 = [char(LetToInc(R1))];
    LetList2 = [char(LetToInc(R2))];
    LetList3 = [char(LetToInc(R3))];
    LetList4 = [char(LetToInc(R4))];
    LetList5 = [char(LetToInc(R5))];
    LetList6 = [char(LetToInc(R6))];
    LetList7 = [char(LetToInc(R7))];
    LetList8 = [char(LetToInc(R8))];
    LetList9 = [char(LetToInc(R9))];
    [LetList1Pos LetList1Neg] = subfnLetLstProbes(LetList1, LetToInc);
    [LetList2Pos LetList2Neg] = subfnLetLstProbes(LetList2, LetToInc);
    [LetList3Pos LetList3Neg] = subfnLetLstProbes(LetList3, LetToInc);
    [LetList4Pos LetList4Neg] = subfnLetLstProbes(LetList4, LetToInc);
    [LetList5Pos LetList5Neg] = subfnLetLstProbes(LetList5, LetToInc);
    [LetList6Pos LetList6Neg] = subfnLetLstProbes(LetList6, LetToInc);
    [LetList7Pos LetList7Neg] = subfnLetLstProbes(LetList7, LetToInc);
    [LetList8Pos LetList8Neg] = subfnLetLstProbes(LetList8, LetToInc);
    [LetList9Pos LetList9Neg] = subfnLetLstProbes(LetList9, LetToInc);
    
    
    LetLists{i}(1).LetList = LetList1;
    LetLists{i}(1).LetListPOS = LetList1Pos;
    LetLists{i}(1).LetListNEG = LetList1Neg;
    LetLists{i}(2).LetList = LetList2;
    LetLists{i}(2).LetListPOS = LetList2Pos;
    LetLists{i}(2).LetListNEG = LetList2Neg;
    LetLists{i}(3).LetList = LetList3;
    LetLists{i}(3).LetListPOS = LetList3Pos;
    LetLists{i}(3).LetListNEG = LetList3Neg;
    LetLists{i}(4).LetList = LetList4;
    LetLists{i}(4).LetListPOS = LetList4Pos;
    LetLists{i}(4).LetListNEG = LetList4Neg;
    LetLists{i}(5).LetList = LetList5;
    LetLists{i}(5).LetListPOS = LetList5Pos;
    LetLists{i}(5).LetListNEG = LetList5Neg;    
    LetLists{i}(6).LetList = LetList6;
    LetLists{i}(6).LetListPOS = LetList6Pos;
    LetLists{i}(6).LetListNEG = LetList6Neg;
    LetLists{i}(7).LetList = LetList7;
    LetLists{i}(7).LetListPOS = LetList7Pos;
    LetLists{i}(7).LetListNEG = LetList7Neg;
    LetLists{i}(8).LetList = LetList8;
    LetLists{i}(8).LetListPOS = LetList8Pos;
    LetLists{i}(8).LetListNEG = LetList8Neg;
    LetLists{i}(9).LetList = LetList9;
    LetLists{i}(9).LetListPOS = LetList9Pos;
    LetLists{i}(9).LetListNEG = LetList9Neg;
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


