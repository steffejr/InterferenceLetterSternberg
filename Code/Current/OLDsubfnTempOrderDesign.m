function [Trials, Events] = subfnTempOrderDesign(NRepeats)
Events = {};
Events{1}.name = 'Load1';
Events{1}.Visual.name = 'Vis_On0_Dur0p5';
Events{1}.Visual.duration = 0.5;
Events{1}.Visual.onset = 0;
Events{1}.Auditory.name = 'Aud_On0p5_Dur0p5';
Events{1}.Auditory.duration = 0.5;
Events{1}.Auditory.onset  = 0.5;

Events{2}.name = 'Load2_AudDelay';
Events{2}.Visual.name = 'Vis_On0_Dur0p5';
Events{2}.Visual.duration = 0.5;
Events{2}.Visual.onset = 0;
Events{2}.Auditory.name = 'Aud_On0p5_Dur1';
Events{2}.Auditory.duration = 1;
Events{2}.Auditory.onset  = 0.5;

Events{3}.name = 'Load2_VisDelay';
Events{3}.Visual.name = 'Vis_On0_Dur1';
Events{3}.Visual.duration = 1;
Events{3}.Visual.onset = 0;
Events{3}.Auditory.name = 'Aud_On1_Dur0p5';
Events{3}.Auditory.duration = 0.5;
Events{3}.Auditory.onset  = 1;

Events{4}.name = 'Load2_VisAudDelay';
Events{4}.Visual.name = 'Vis_On0_Dur1';
Events{4}.Visual.duration = 1.0;
Events{4}.Visual.onset = 0;
Events{4}.Auditory.name = 'Aud_On1_Dur1';
Events{4}.Auditory.duration = 1.0;
Events{4}.Auditory.onset  = 1.0;

TrialOrder = repmat([1:4],1,NRepeats)';
NTrials = length(TrialOrder);
TrialOrder = TrialOrder(randperm(NTrials));


Trials = cell(NTrials,1);
for i = 1:NTrials
    Trials{i} = Events{TrialOrder(i)};
end









