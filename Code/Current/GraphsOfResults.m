

[FileName PathName] = uigetfile('iLS*.mat','Select one file from a subject');
cd(PathName)
% find the subject ID
FindUnder = findstr(FileName,'_');
subid = FileName(FindUnder(1)+1 : FindUnder(2)-1);
% find all files from teh same subject
D = dir(['iLS_' subid '*.mat']);
% cycle over the files and display the results
ResultsColumns = [2 6 99];
OutputString = '';
f = figure;
NumPlots = 6;
set(f,'Name',['Subject: ' subid]);
for i = 1:length(D)
    clear ExperimentParameters
    load(D(i).name);
    
    tempLetAcc = [ExperimentParameters.Results{2}.LetterAccuracy ...
        ExperimentParameters.Results{6}.LetterAccuracy];
    
    tempLetmedRT = [ExperimentParameters.Results{2}.LetterMedianResponseTime ...
        ExperimentParameters.Results{6}.LetterMedianResponseTime];
    
    tempNumAcc = [ExperimentParameters.Results{99}.NumberLowAccuracy ...
        ExperimentParameters.Results{99}.NumberHighAccuracy];
    
    tempNummedRT = [ExperimentParameters.Results{99}.NumberMedianLowResponseTime ...
        ExperimentParameters.Results{99}.NumberMedianHighResponseTime];
    
    tempLetTO = [ExperimentParameters.Results{2}.LetterTO ...
        ExperimentParameters.Results{6}.LetterTO];
    
    tempNumTO = [ExperimentParameters.Results{99}.NumberTO];

    subplot(length(D),NumPlots,(i-1)*NumPlots+1)
    bar([2 6],tempLetAcc)
    axis([1 7 0 1.1])
    if i == 1
        title('LetAcc')
    end
    ylabel(['Run ' num2str(i)])
    
    subplot(length(D),NumPlots,(i-1)*NumPlots+2)
    bar([2 6],tempLetmedRT)
    axis([1 7 0 4])
    if i == 1
        title('Let medRT')
    end
    
    subplot(length(D),NumPlots,(i-1)*NumPlots+3)
    bar([2 6],tempNumAcc)
    axis([1 7 0 1.1])
    if i == 1
        title('Num Acc')
    end
    
    subplot(length(D),NumPlots,(i-1)*NumPlots+4)
    bar([2 6],tempNummedRT)
    axis([1 7 0 4])
    if i == 1
        title('Num medRT')
    end
    
    subplot(length(D),NumPlots,(i-1)*NumPlots+5)
    bar([2 6],tempLetTO)
    %axis([1 7 0 5])
    if i == 1
        title('Let TO')
    end
    
    subplot(length(D),NumPlots,(i-1)*NumPlots+6)
    bar([1],tempNumTO)
    %axis([0 2 0 5])
    if i == 1
        title('Num TO')
    end
end
