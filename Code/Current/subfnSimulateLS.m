
ConfigFile = 'C:\Users\Makaye\Desktop\SteffenerColumbia\Grants\K\TaskDesign\InterferenceLetterSternberg\ConfigFiles\iLSConfigMontpellierMRIv2.txt';
[handles] = subfnReadConfigFile(ConfigFile);

NRepeats = 5;
NumberListLength = 0;
LoadLevels = [1 3 6];

[Trials Design] = subfnCreateDesign(NRepeats,NumberListLength, LoadLevels, handles);
NTrials = length(Trials);
IntroDelay =        handles.IntroDelay;
EncodeTime =        handles.EncodeTime;
PreRetTime =        handles.PreRetTime;
RetentionTime =     handles.RetentionTime;
PostRetTime =       handles.PostRetTime;
ProbeTime =         handles.ProbeTime;
FinalDelay =          handles.FinalDelay;
% Wait time for instructions
WaitTime = handles.WaitTime;
ITI = subfnCreateITI(NTrials);
ITI(1) = 0;
ExpectedMeanITI = mean(ITI);

    ExperimentParameters.Design = Design;
            StartTrialTime = IntroDelay;
            for i = 1:NTrials
                Trials{i}.EncodeStartTime = StartTrialTime;
                Trials{i}.PreRetStartTime = Trials{i}.EncodeStartTime + EncodeTime;
                Trials{i}.RetentionStartTime = Trials{i}.PreRetStartTime + PreRetTime;
                Trials{i}.PostRetStartTime = Trials{i}.RetentionStartTime + RetentionTime;
                Trials{i}.ProbeStartTime = Trials{i}.PostRetStartTime + PostRetTime;
                Trials{i}.ITIStartTime = Trials{i}.ProbeStartTime + ProbeTime;
                Trials{i}.ITIDuration = ITI(i);
                StartTrialTime = Trials{i}.ITIStartTime + ITI(i);
                Trials{i}.LetterResponseTime = SimRT(i,1);
                if ~isempty(strfind(Trials{i}.LetType,'NEG'))
                    Trials{i}.LetterResponseAcc = 'CR';
                else
                    Trials{i}.LetterResponseAcc = 'HT';
                end
                Trials{i}.NumberResponseTime = SimRT(i,2);
                if ~isempty(strfind(Trials{i}.NumType,'NEG'))
                    Trials{i}.NumberResponseAcc = 'CR';
                else
                    Trials{i}.NumberResponseAcc = 'HT';
                end
            end
            
            ExperimentParameters.Trials = Trials;
            
            [names durations onsets] = subfnCreateSPMDesignMatrix(ExperimentParameters);
 