function WIPsubfnStats
% What comparisons am I interested in?
% Is there an effect of letter load on accuracy?
%   collapse number task
%   collapse across letter probe types
%   test across letter loads
% Is there an effect of the intervening number task on letter accuracy?
%   collapse number task
% How do I code the trials where letters was accurate but the number was
% incorrect?
% How do I code the trials where letters was incorrect but numbers was
% correct?
% 


% 2Let Correct/LowNum Correct
24 2 letter 
24 6 letter
24 low number
24 high number
2LetCORLowNumCOR    X1 (at most 12)
2LetCORLowNumINC    12 - X1
2LetCORHighNumCOR   X2 (at most 12)
2LetCORHighNumINC   12 - X2
6LetCORLowNumCOR    
6LetCORLowNumINC
6LetCORHighNumCOR
6LetCORHighNumINC


% Select ONE Result file for a subject and display all of their results.
[FileName PathName] = uigetfile('iLS*.mat','Select one file from a subject');
% find the subject ID
FindUnder = findstr(FileName,'_');
subid = FileName(FindUnder(1)+1 : FindUnder(2)-1);
% find all files from teh same subject
D = dir(['iLS_' subid '*.mat']);
Nruns = length(D);
Design = [];
Trials = [];
% collapse across the two test runs
for i = Nruns-1:Nruns
    clear ExperimentParameters
    load(D(i).name)
    Design = [Design; ExperimentParameters.Design];
    Trials = [Trials; ExperimentParameters.Trials];
end
NTrials = length(Trials);
AllNumRT = zeros(NTrials,1);
AllLetRT = zeros(NTrials,1);
for i = 1:NTrials
    if ~strcmp(Trials{i}.NumberResponseAcc,'TO')
        AllNumRT(i,1) = Trials{i}.NumberResponseTime(max(find(Trials{i}.NumberResponseTime ~= -99)));
    end
    if ~strcmp(Trials{i}.LetterResponseAcc,'TO')
        AllLetRT(i,1) = Trials{i}.LetterResponseTime(max(find(Trials{i}.LetterResponseTime ~= -99)));
    end
end

VarNames = {'LetLoad','NumLoad','LetPro','NumPro'};
VarNames = {'LetLoad','NumLoad'}%,'LetPro','NumPro'};

[P,T,STATS,TERMS]=anovan(AllNumRT,Design,'display','on','varnames',VarNames,'model','full');
[P,T,STATS,TERMS]=anovan(AllLetRT,Design,'display','on','varnames',VarNames,'model','full');
[P,T,STATS,TERMS]=anovan(AllNumRT,Design,'display','on','varnames',VarNames,'model','interaction');
[P,T,STATS,TERMS]=anovan(AllLetRT,Design,'display','on','varnames',VarNames,'model','interaction');
[P,T,STATS,TERMS]=anovan(AllNumRT,Design,'display','on','varnames',VarNames,'model','linear');
[P,T,STATS,TERMS]=anovan(AllLetRT,Design,'display','on','varnames',VarNames,'model','linear');
dim = [1 2];
[c,m,h,nms] = multcompare(STATS,'display','on','dimension',dim);


