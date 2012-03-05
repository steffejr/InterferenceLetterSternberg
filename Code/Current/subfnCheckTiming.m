[FileName PathName] = uigetfile('iLS*.mat','Select one file from a subject');
cd(PathName)
% find the subject ID
FindUnder = findstr(FileName,'_');
subid = FileName(FindUnder(1)+1 : FindUnder(2)-1);
% find all files from teh same subject
D = dir(['iLS_' subid '*.mat']);
%function subfnCheckTiming(ExperimentParameters)
%% Needed
% A program to check to see if the timing is correct
figure
for j = 1:length(D)
    clear ExperimentParameters
    load(D(j).name);
    TrialDuration = ExperimentParameters.Timings.EncodeTime + ...
        ExperimentParameters.Timings.PreRetTime + ...
        ExperimentParameters.Timings.RetentionTime + ...
        ExperimentParameters.Timings.PostRetTime + ...
        ExperimentParameters.Timings.ProbeTime;
    
    NTrials = length(ExperimentParameters.Trials);
    % Encode/PreRet/Ret/PostRet/Probe
    % Trial
    % Expected/Real
    Times = zeros(5,NTrials,2);
    Times(1,1,1) = ExperimentParameters.Trials{1}.ITIDuration + ExperimentParameters.Timings.IntroDelay;
    Times(1,1,2) = ExperimentParameters.Trials{1}.EncodeStartTime;
    % Times(3,1,1) = ExperimentParameters.Trials{1}.ITIDuration + ExperimentParameters.Timings.IntroDelay;
    % Times(4,1,1) = ExperimentParameters.Trials{1}.ITIDuration + ExperimentParameters.Timings.IntroDelay;
    % Times(5,1,1) = ExperimentParameters.Trials{1}.ITIDuration + ExperimentParameters.Timings.IntroDelay;
    for i = 2:NTrials
        Times(1,i,1) = Times(1,i-1,1) + TrialDuration + ExperimentParameters.Trials{i}.ITIDuration;
        Times(1,i,2) = ExperimentParameters.Trials{i}.EncodeStartTime;
        
    end
    subplot(length(D),2,(j-1)*2+1)
    t = title(D(j).name);
    set(t,'Interpreter','none');
    hold on
    plot(squeeze(Times(1,:,1)),'.-');
    plot(squeeze(Times(1,:,2)),'r.-');
    legend('Expected','Actual')
    xlabel('Trial Number');
    ylabel('seconds')
    subplot(length(D),2,j*2);
  
    plot(squeeze(Times(1,:,1)) - squeeze(Times(1,:,2)),'.-')
    ylabel('Difference (seconds)')
    xlabel('Trial Number');
end