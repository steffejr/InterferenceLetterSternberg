[FileName PathName] = uigetfile('iLS*.mat','Select one file from a subject');
cd(PathName)
% find the subject ID
FindUnder = findstr(FileName,'_');
subid = FileName(FindUnder(1)+1 : FindUnder(2)-1);
% find all files from teh same subject
D = dir(['iLS_' subid '*.mat']);

for j = 1:length(D)
    clear ExperimentParameters
    load(D(j).name);
    [names onsets durations] = CreateSPMRegressors(ExperimentParameters.Trials);
    [PathName FileName] = fileparts(D(j).name);
    OutName = fullfile(pwd,[FileName '_SPM']);
    Str = ['save ' OutName ' names onsets durations']
    eval(Str)
end