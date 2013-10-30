
[FileName PathName] = uigetfile('DUMP*.mat','Select one file from a subject');
load(fullfile(PathName,FileName))
s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);

[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_PILOTConfig.txt'));

Buttons.NumberNo       = handles.Buttons_NumberNo;
Buttons.NumberYes        = handles.Buttons_NumberYes;
Buttons.LetterNo       = handles.Buttons_LetterNo;
Buttons.LetterYes        = handles.Buttons_LetterYes;

NTrials = 48;
Design = zeros(NTrials,4);
count = 0;
try
    for i = 1:NTrials
        Design(i,1) = str2num(Trials{i}.LetType(1));
        Design(i,2) = 1;
        if ~isempty(strfind(Trials{i}.LetType,'POS'))
            Design(i,3) = 1;
        elseif ~isempty(strfind(Trials{i}.LetType,'NEG'))
            Design(i,3) = -1;
        end
        Design(i,4) = 1;
        Trials{i}.EncodeStartTime       = TrialTimes(i + 2,1) - TrialTimes(1,1);
        Trials{i}.PreRetStartTime       = TrialTimes(i + 2,2) - TrialTimes(1,1);
        Trials{i}.RetentionStartTime    = TrialTimes(i + 2,3) - TrialTimes(1,1);
        Trials{i}.PostRetStartTime      = TrialTimes(i + 2,4) - TrialTimes(1,1);
        Trials{i}.ProbeStartTime        = TrialTimes(i + 2,5) - TrialTimes(1,1);
        Trials{i}.ITIStartTime          = TrialTimes(i + 2,6) - TrialTimes(1,1);
        Trials{i}.ITIDuration           = (TrialTimes(i + 3,1) - TrialTimes(1,1)) - (TrialTimes(i + 2,6) - TrialTimes(1,1));
        count = count + 1;
    end
catch me
end
NTrials = count;
Design = Design(1:NTrials,:);


EP.Trials = Trials(1:NTrials);
EP.Design = Design;
EP.Buttons = Buttons;
EP.RunConditions.MRITrigger = handles.Trigger2;
[Trials Results] = subfnCorrectResponses_LetNum(EP);
EP.Trials = Trials;
EP.Results = Results;
ExperimentParameters = EP;

FileName = FileName(6:end);
FindUnders = findstr(FileName,'_');
subid = FileName(FindUnders(2)+1:FindUnders(3)-1);
Run = FileName(FindUnders(3)+1:FindUnders(4)-1);
DateTime = FileName(FindUnders(4)+1:FindUnders(6)-1);

Str = sprintf('save %s ExperimentParameters',fullfile(PathName, FileName));
eval(Str)
DurTimes = [9 3 -1 3];
LetLoad = [1:8];
[names onsets durations] = CreateSPMRegressors_xLS(ExperimentParameters.Trials,LetLoad,DurTimes);
Str = sprintf('save %s names onsets durations',fullfile(PathName,sprintf('SPM_%s_%s_%s',subid,Run,DateTime)));
eval(Str)


