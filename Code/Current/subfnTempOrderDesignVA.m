function [Trials, Events] = subfnTempOrderDesignVA(NRepeats, VariableDuration)

Events = {};
Events{1}.name = 'V1A1';
Events{1}.Visual.name = 'Vis_On0_Dur0p5';
Events{1}.Visual.duration = 0.5;
Events{1}.Visual.onset = 0;
Events{1}.Auditory.name = 'Aud_On0p5_Dur0p5';
Events{1}.Auditory.duration = 0.5;
Events{1}.Auditory.onset  = 0.5;

Events{2}.name = 'V1A2';
Events{2}.Visual.name = 'Vis_On0_Dur0p5';
Events{2}.Visual.duration = 0.5;
Events{2}.Visual.onset = 0;
Events{2}.Auditory.name = 'Aud_On0p5_Dur1';
Events{2}.Auditory.duration = 1;
Events{2}.Auditory.onset  = 0.5;

Events{3}.name = 'V2A1';
Events{3}.Visual.name = 'Vis_On0_Dur1';
Events{3}.Visual.duration = 1;
Events{3}.Visual.onset = 0;
Events{3}.Auditory.name = 'Aud_On1_Dur0p5';
Events{3}.Auditory.duration = 0.5;
Events{3}.Auditory.onset  = 1;

Events{4}.name = 'V2A2';
Events{4}.Visual.name = 'Vis_On0_Dur1';
Events{4}.Visual.duration = 1.0;
Events{4}.Visual.onset = 0;
Events{4}.Auditory.name = 'Aud_On1_Dur1';
Events{4}.Auditory.duration = 1.0;
Events{4}.Auditory.onset  = 1.0;
% 
% Events{5}.name = 'A1V1';
% Events{5}.Visual.name = 'Vis_On0p5_Dur0p5';
% Events{5}.Visual.duration = 0.5;
% Events{5}.Visual.onset = 0.5;
% Events{5}.Auditory.name = 'Aud_On0_Dur0p5';
% Events{5}.Auditory.duration = 0.5;
% Events{5}.Auditory.onset  = 0;
% 
% Events{6}.name = 'A1V2';
% Events{6}.Visual.name = 'Vis_On0p5_Dur1';
% Events{6}.Visual.duration = 1;
% Events{6}.Visual.onset = 0.5;
% Events{6}.Auditory.name = 'Aud_On0_Dur0p5';
% Events{6}.Auditory.duration = 0.5;
% Events{6}.Auditory.onset  = 0;
% 
% Events{7}.name = 'A2V1';
% Events{7}.Visual.name = 'Vis_On1_Dur0p5';
% Events{7}.Visual.duration = 0.5;
% Events{7}.Visual.onset = 1;
% Events{7}.Auditory.name = 'Aud_On0_Dur1';
% Events{7}.Auditory.duration = 1;
% Events{7}.Auditory.onset  = 0;
% 
% Events{8}.name = 'A2V2';
% Events{8}.Visual.name = 'Vis_On1_Dur1';
% Events{8}.Visual.duration = 1;
% Events{8}.Visual.onset = 1;
% Events{8}.Auditory.name = 'Aud_On0_Dur1';
% Events{8}.Auditory.duration = 1;
% Events{8}.Auditory.onset  = 0;
% 


TrialOrder = repmat([1:length(Events)],1,NRepeats)';
NTrials = length(TrialOrder);
TrialOrder = TrialOrder(randperm(NTrials));
if VariableDuration
    VarDur = rand(NTrials,1)*0.5 - 0.25;
    SplitTime = rand(NTrials,1);
else
    VarDur = zeros(NTrials,2);
end
% This makes sure that the added time to the trials is uniformly
% distributed
VarDur = [VarDur.*SplitTime VarDur.*(1-SplitTime)];

Trials = cell(NTrials,1);
for i = 1:NTrials
    tempTrial = Events{TrialOrder(i)};
    if strfind(tempTrial.name,'V')<strfind(tempTrial.name,'A')
        % Visual first
        tempTrial.Visual.duration = tempTrial.Visual.duration + VarDur(i,1);
        tempTrial.Auditory.onset = tempTrial.Visual.duration;
        tempTrial.Auditory.duration = tempTrial.Auditory.duration + VarDur(i,2);
        Trials{i} = tempTrial;
    else
        % Auditory First
        tempTrial.Auditory.duration = tempTrial.Auditory.duration + VarDur(i,1);
        tempTrial.Visual.onset = tempTrial.Auditory.duration;
        tempTrial.Visual.duration = tempTrial.Visual.duration + VarDur(i,2);
        Trials{i} = tempTrial;
    end
end







