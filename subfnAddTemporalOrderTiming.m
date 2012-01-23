function Trials = subfnAddTemporalOrderTiming(IntroOff, Trials,ITI,TrialDuration)
NTrials = length(Trials);
ElapsedTime = IntroOff;

% Make each trial 4 seconds long
% this is enough time for the 1sec Vis + 1sec Aud + 2 sec RT
% Then is the ITI 
for i = 1:NTrials
    Trials{i}.Visual.ExpectedOn = ElapsedTime;
    Trials{i}.Auditory.ExpectedOn = ElapsedTime + Trials{i}.Visual.duration;
    ElapsedTime = ElapsedTime + TrialDuration + ITI(i);
end