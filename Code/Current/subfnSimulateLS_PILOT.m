clear
BaseDir = 'C:\Users\steffener\Dropbox\SteffenerColumbia\Scripts\InterferenceLetterSternberg'
%BaseDir = '/Users/jason/Dropbox/SteffenerColumbia/Scripts/InterferenceLetterSternberg';
BaseDir = '/Users/jason/Dropbox/SteffenerColumbia/Scripts/InterferenceLetterSternberg'

ConfigFile = fullfile(BaseDir,'ConfigFiles','iLS_Modified_Config.txt')
DesignDir = fullfile(BaseDir,'SPMDesignJobs');
[handles] = subfnReadConfigFile(ConfigFile);


IntroDelay =        handles.IntroDelay;
EncodeTime =        handles.EncodeTime;
PreRetTime =        handles.PreRetTime;
RetentionTime =     handles.RetentionTime;
PostRetTime =       handles.PostRetTime;
ProbeTime =         handles.ProbeTime;
FinalDelay =          handles.FinalDelay;
WaitTime = handles.WaitTime;
TrialTime = EncodeTime + PreRetTime + RetentionTime + PostRetTime + ProbeTime;

NScan = 320;


NTrials = 40;
NDesigns = 100;
NITIs = 100;

NumberListLength = 0;
LoadLevels = [1 3 5 7 9];
NRepeats = 4;

OptimalITI = zeros(NTrials,1);
OptimalTrials = [];
OptimalEff = zeros(1,6);


spm_jobman('initcfg')
AllOptimalTrials = cell(NDesigns,1);

AllOptimalITI = cell(NDesigns,1);
%Filters = [32:32:256];
Filters = 128;
ITIGamma = [0.5:0.2:4]
ITIGamma = 2.7;
NSess = 1;
AllOptimalEff = zeros(NITIs,length(ITIGamma),length(Filters),length(LoadLevels));
ProbError = zeros(1,max(LoadLevels));
%ProbError(8) = 0.8;
%
DurEff = zeros(NDesigns*NITIs,length(LoadLevels));
NTrialsPerLoad = zeros(NDesigns*NITIs,length(LoadLevels) + 1);
for j = 1:NDesigns
    fprintf(1,'Working on Design %d of %d\n',j,NDesigns);
    % Make sure that a good design is made
    BadDesignFlag = 1;
    while BadDesignFlag
        [Trials Design] = subfnCreateDesign(NRepeats,NumberListLength, LoadLevels, handles);
        NTrials = length(Trials);
        if ~isempty(Design)
            BadDesignFlag = 0;
        end
    end
    for k = 1:NITIs
        for gg = 1:length(ITIGamma)
            GG = ITIGamma(gg);
            R = round(randg(ones(NTrials,1))*GG*10)/10;
            ITI = R + 1;
            %ITI = subfnCreateITI_iLS(NTrials);
            ITI(1) = 0;
            ExpectedMeanITI = mean(ITI);
            SimRT = gamrnd(2,0.2*ones(NTrials,2))+0.4;
            StartTrialTime = IntroDelay;
            for i = 1:NTrials
                ExperimentParameters.Design = Design;
                Trials{i}.EncodeStartTime = StartTrialTime;
                Trials{i}.PreRetStartTime = Trials{i}.EncodeStartTime + EncodeTime;
                Trials{i}.RetentionStartTime = Trials{i}.PreRetStartTime + PreRetTime;
                Trials{i}.PostRetStartTime = Trials{i}.RetentionStartTime + RetentionTime;
                Trials{i}.ProbeStartTime = Trials{i}.PostRetStartTime + PostRetTime;
                Trials{i}.ITIStartTime = Trials{i}.ProbeStartTime + ProbeTime;
                Trials{i}.ITIDuration = ITI(i);
                StartTrialTime = Trials{i}.ITIStartTime + ITI(i);
                % Add some probability of error
                INCORRECT = rand < ProbError(str2num(Trials{i}.LetType(1)));
                if ~INCORRECT
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
                else
                    Trials{i}.LetterResponseTime = SimRT(i,1);
                    if ~isempty(strfind(Trials{i}.LetType,'NEG'))
                        Trials{i}.LetterResponseAcc = 'FA';
                    else
                        Trials{i}.LetterResponseAcc = 'MS';
                    end
                    Trials{i}.NumberResponseTime = SimRT(i,2);
                    if ~isempty(strfind(Trials{i}.NumType,'NEG'))
                        Trials{i}.NumberResponseAcc = 'FA';
                    else
                        Trials{i}.NumberResponseAcc = 'MS';
                    end
                end
            end
            
            % RetDur = [0.1:0.2:7];
            % for i = 1:length(RetDur)
            %Dur = [3 5 3];
            %Dur = [EncodeTime  RetentionTime+PreRetTime+PostRetTime ProbeTime];
            Dur = [-1 3 3];
            subid = 'TEST';
            
            %[names onsets durations] = CreateSPMRegressors(ExperimentParameters.Trials,LoadLevels,Dur);
            ExperimentParameters1.Trials = Trials;
            [names onsets durations] = CreateSPMRegressors_xLS(ExperimentParameters1.Trials,LoadLevels,Dur);
            FileName1 = fullfile(DesignDir,[subid '_DesignSPM1' '.mat']);
            str = ['save ' FileName1 ' names durations onsets'];
            eval(str)
            if NSess == 3
                ExperimentParameters2.Trials = Trials(randperm(NTrials));
                [names onsets durations] = CreateSPMRegressors_xLS(ExperimentParameters2.Trials,LoadLevels,Dur);
                FileName2 = fullfile(DesignDir,[subid '_DesignSPM2' '.mat']);
                str = ['save ' FileName2 ' names durations onsets'];
                eval(str)
                
                ExperimentParameters3.Trials = Trials(randperm(NTrials));
                [names onsets durations] = CreateSPMRegressors_xLS(ExperimentParameters3.Trials,LoadLevels,Dur);
                FileName3 = fullfile(DesignDir,[subid '_DesignSPM3' '.mat']);
                str = ['save ' FileName3 ' names durations onsets'];
                eval(str)
            end
            
            TR = 2;
            
            
            hpf = 128;
            
            %job = subfnCreateDesignJob(FileName, TR, hpf);
            
            P = fullfile(DesignDir,'BLANK_OneSessionSpecify');
            if NSess == 3
                P = fullfile(DesignDir,'BLANK_ThreeSessionSpecify');
            end
            load(P)
            
            delete(fullfile(DesignDir,'SPM.mat'));
            
            matlabbatch{1}.spm.stats.fmri_design.dir = {DesignDir};
            matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
            matlabbatch{1}.spm.stats.fmri_design.timing.RT = TR;
            
            TotalTime = NTrials*TrialTime + sum(ITI) + IntroDelay;
            % add ten then round up to the nearest 6
            FinalDelay = 10 + 6 - mod(TotalTime,6);
            TotalTime = TotalTime + FinalDelay;
            NScan = TotalTime / TR;
            
            matlabbatch{1}.spm.stats.fmri_design.sess(1).nscan = NScan;
            matlabbatch{1}.spm.stats.fmri_design.sess(1).multi = {FileName1};
            if NSess == 3
                matlabbatch{1}.spm.stats.fmri_design.sess(2).nscan = NScan;
                matlabbatch{1}.spm.stats.fmri_design.sess(2).multi = {FileName2};
                matlabbatch{1}.spm.stats.fmri_design.sess(3).nscan = NScan;
                matlabbatch{1}.spm.stats.fmri_design.sess(3).multi = {FileName3};
            end
            spm_jobman('run',matlabbatch)
            %spm_jobman('interactive',matlabbatch)
            load(fullfile(DesignDir,'SPM.mat'))
            
            [m n] = size(SPM.xX.X);
            [SPM] = subfnCreateContrats_xLS(SPM,LoadLevels);
            [eff VRF BoldEffect] = subfnCalcModelEfficiency_iLS(SPM);
            DurEff(j,:) = eff;
            for kk = 1:length(onsets)
                NTrialsPerLoad(j,kk) = length(onsets{kk});
            end
            
            if sum(eff) > sum(OptimalEff)
                OptimalEff = eff;
                OptimalITI = ITI;
                OptimalFilter = hpf;
                OptimalGamma = GG;
                OptimalTrials = Trials;
                OptimalDesign = Design;
                OptimalNScan = NScan;
            end
            AllOptimalEff(k,gg,j,:) = eff;
            
        end
    end
    
    AllOptimalITI{j} = OptimalITI;
    AllOptimalTrials{j} = Trials;
    
end



%             SumEff(kk,mm,jj,1)=sum(eff([7 8 9 10 11 18 19 20 21 22]));
%             SumEff(kk,mm,jj,2)=sum(eff);
%             SumBE(kk,mm,jj,1) = sum(BoldEffect([7 8 9 10 11 18 19 20 21 22]));
%             SumBE(kk,mm,jj,2)=sum(BoldEffect);
%


sum(Dur)*NTrials+sum(OptimalITI)+IntroDelay+FinalDelay
OptimalEff