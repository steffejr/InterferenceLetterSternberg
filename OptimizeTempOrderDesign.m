% Intro OFF Time in seconds
IntroOff = 12;
% how many blocks of the four trials types are to be presented
NRepeats = 5;
% Create the trials in random order
[Trials Events] = subfnTempOrderDesign(NRepeats,1);
% How many trials were created, this will be 4*NRepeats
NTrials = length(Trials);
% create the ITI time array
%ITI = subfnTemporalOrderITI(NTrials);
%%
dt = 0.01;
hrf = spm_hrf(dt);
% This is related to the spread in the gamma distribution of ITI
G = 1.5;
% THis is the maximum time allowed to respond for each trial and the
% minimum ITI.
offset = 2; % Seconds

% Now the aim is to identify the best order of trials and the best
% distribution of ITIs
BestITI = zeros(NTrials,1);
BestTrials = {};
BestTotalEff = 0;
BestEff = zeros(1,4);
TrialDuration = 4;
MaxResponseTime = 2;
%% Different trial orders
for i = 1:100
    fprintf(1,'Trial: %3d\n',i);
    [Trials Events] = subfnTempOrderDesign(NRepeats,1);
    % Different distributions of ITIs
    for j = 1:100
        ITI = subfnTemporalOrderITI(NTrials,G,offset);
        %ITI = ones(NTrials,1);
        % The maximum time allowed for a response tyo be made. Note that the ITI
        % for each trial (created above) will have this value ADDED to it.
        
        % Add the ITI times to the Trial structure along with expected times. Then
        % add the actual times to teh Trials which will alow for a check of actual
        % versus expected for any time delays
        %[Trials] = subfnAddTemporalOrderTiming(IntroOff, Trials,ITI,TrialDuration);
         Trials = subfnAddTemporalOrderTiming(IntroOff, Trials,ITI,MaxResponseTime);
        Trials = subfnCreateRandomResponseTimes(Trials);
        [names onsets durations] = subfnCreateRegressors(Trials, Events);
        [eff tempTotalEff X TotalTime] = subfnCalculateDesignEffTempOrder(names,durations,onsets,Trials,hrf);
        if tempTotalEff > BestTotalEff
        %if sum(eff>BestEff) == 4
            BestITI = ITI;
            BestTrials = Trials;
            BestTotalEff = tempTotalEff;
            BestEff = eff;
        end
    end
end

%% Inspect the best Design
[names onsets durations] = subfnCreateRegressors(BestTrials, Events);
[eff TotalEff X TotalTime] = subfnCalculateDesignEffTempOrder(names,durations,onsets,BestTrials,hrf);
eff
TotalTime
TotalTime/60
TotalEff
figure(1)
plot(X(:,1:8));
%%

%fprintf(1,'Total eff: %0.2f, Total Time: %0.0f sec, %0.2f min\n',TotalEff,TotalTime,TotalTime/60)


