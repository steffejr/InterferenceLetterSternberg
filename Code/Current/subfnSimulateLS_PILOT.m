BaseDir = 'C:\Users\steffener\Dropbox\SteffenerColumbia\Scripts\InterferenceLetterSternberg'
ConfigFile = fullfile(BaseDir,'ConfigFiles','iLS_PILOTConfig.txt')
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


NScan = 374;
NTrials=48;
NDesigns = 5;
NITIs = 100;

NumberListLength = 0;
LoadLevels = [1 2 3 4 5 6 7 8];
NRepeats = 3;

OptimalITI = zeros(NTrials,1);
OptimalTrials = [];
OptimalEff = zeros(1,6);


spm_jobman('initcfg')
AllOptimalTrials = cell(NDesigns,1);
AllOptimalEff = cell(NDesigns,1);
AllOptimalITI = cell(NDesigns,1);
for j = 1:NDesigns
    fprintf(1,'Working on Design %d of %d\n',j,NDesigns);
    [Trials Design] = subfnCreateDesign(NRepeats,NumberListLength, LoadLevels, handles);
    NTrials = length(Trials);
    for k = 1:NITIs
        R = round(randg(ones(NTrials,1))*2*10)/10;
        ITI = R + 2;
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
        % RetDur = [0.1:0.2:7];
        % for i = 1:length(RetDur)
        %Dur = [3 5 3];
        Dur = [EncodeTime  RetentionTime+PreRetTime+PostRetTime ProbeTime];
        [names onsets durations] = CreateSPMRegressors(ExperimentParameters.Trials,LoadLevels,Dur);
        
        subid = 'TEST';
        FileName = fullfile(DesignDir,[subid '_DesignSPM' '.mat']);
        str = ['save ' FileName ' names durations onsets'];
        eval(str)
        Input = load(FileName);
        TR = 2;
        hpf = 128;
        
        %job = subfnCreateDesignJob(FileName, TR, hpf);
        
        P = fullfile(DesignDir,'BLANK_OneSessionSpecify');
        load(P)
        
        delete(fullfile(DesignDir,'SPM.mat'));
        
        matlabbatch{1}.spm.stats.fmri_design.dir = {DesignDir};
        matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
        matlabbatch{1}.spm.stats.fmri_design.timing.RT = TR;
        
        matlabbatch{1}.spm.stats.fmri_design.sess.nscan = 300;
        matlabbatch{1}.spm.stats.fmri_design.sess.multi = {FileName};
        spm_jobman('run',matlabbatch)
        
        load(fullfile(DesignDir,'SPM.mat'))
        
        [m n] = size(SPM.xX.X);
        [SPM] = subfnCreateContrats_LS(SPM,LoadLevels);
        [eff VRF BoldEffect] = subfnCalcModelEfficiency_iLS(SPM);
        DurEff(k,:) = eff;
        if sum(eff) > sum(OptimalEff)
            OptimalEff = eff;
            OptimalITI = ITI;
            OptimalTrials = Trials;
        end
    end
    AllOptimalITI{j} = OptimalITI;
    AllOptimalTrials{j} = Trials;
    AllOptimalEff{j} = OptimalEff;
end

%             SumEff(kk,mm,jj,1)=sum(eff([7 8 9 10 11 18 19 20 21 22]));
%             SumEff(kk,mm,jj,2)=sum(eff);
%             SumBE(kk,mm,jj,1) = sum(BoldEffect([7 8 9 10 11 18 19 20 21 22]));
%             SumBE(kk,mm,jj,2)=sum(BoldEffect);
%


sum(Dur)*NTrials+sum(OptimalITI)+IntroDelay+FinalDelay
