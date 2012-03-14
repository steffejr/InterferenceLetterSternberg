[FileName PathName] = uigetfile('TempOrd*.mat','Select one file from a subject');
cd(PathName)
% find the subject ID
FindUnder = findstr(FileName,'_');
subid = FileName(FindUnder(1)+1 : FindUnder(2)-1);
% find all files from teh same subject
D = dir(['TempOrd_' subid '*.mat']);
%function subfnCheckTiming(ExperimentParameters)
%% Needed
% A program to check to see if the timing is correct
figure
for j = 1:length(D)
    clear TempOrderData
    load(D(j).name);
    NTrials = length(TempOrderData.Trials);
    ActualOn = zeros(NTrials,2);
    ExpectedOn = zeros(NTrials,2);
    for i = 1:NTrials
        ActualOn(i,1) = TempOrderData.Trials{i}.Visual.ActualOn;
        ActualOn(i,2) = TempOrderData.Trials{i}.Auditory.ActualOn;
        ExpectedOn(i,1) = TempOrderData.Trials{i}.Visual.ExpectedOn;
        ExpectedOn(i,2) = TempOrderData.Trials{i}.Auditory.ExpectedOn;
    end
    Differences = [ExpectedOn(:,1)-ActualOn(:,1) ExpectedOn(:,2)-ActualOn(:,2)]
end


        
        