function Trials = subfnAddTemporalOrderTiming(IntroOff, Trials,ITI,MaxResponseTime)
NTrials = length(Trials);
ElapsedTime = IntroOff;

% Make each trial 4 seconds long
% this is enough time for the 1sec Vis + 1sec Aud + 2 sec RT
% Then is the ITI 
for i = 1:NTrials
        TrialDuration = Trials{i}.Visual.duration + Trials{i}.Auditory.duration;
        Trials{i}.Visual.ExpectedOn = ElapsedTime + Trials{i}.Visual.onset;
        Trials{i}.Auditory.ExpectedOn = ElapsedTime + Trials{i}.Auditory.onset;
        Trials{i}.ITI = ITI(i);
        ElapsedTime = ElapsedTime + TrialDuration + ITI(i) + MaxResponseTime;
end