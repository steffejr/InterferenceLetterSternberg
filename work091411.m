spm_jobman('initcfg')
BaseDir = 'C:\Users\jsteffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LetterSternbergWithInterference';
ResultsDir = fullfile(BaseDir,'Results');
DesignDir = fullfile(BaseDir,'SPMDesign');
cd(DesignDir)


NTrials = 32;
% Need to create DUMMY designs to optimize the design with.
% Timings
IntroDelay =        5.000;
% Encode/PreRet/Retion/PostRet/Probe/ITI
EncodeTime =        3.000; % seconds
PreRetTime =        0.500;
RetentionTime =     6.000;
PostRetTime =       0.500;
ProbeTime =         3.000;
% Wait time for instructions
WaitTime = 5;


%SimRT = randg(zeros(NTrials,2))+0.5;
SimRT = gamrnd(2,0.2*ones(NTrials,2))+0.4;

ExpectedWithinTrialElaspsedTimes = [];
ExpectedWithinTrialElaspsedTimes(1,1) = 0;
ExpectedWithinTrialElaspsedTimes(2,1) = ExpectedWithinTrialElaspsedTimes(1) + EncodeTime;
ExpectedWithinTrialElaspsedTimes(3,1) = ExpectedWithinTrialElaspsedTimes(2) + PreRetTime;
ExpectedWithinTrialElaspsedTimes(4,1) = ExpectedWithinTrialElaspsedTimes(3) + RetentionTime;
ExpectedWithinTrialElaspsedTimes(5,1) = ExpectedWithinTrialElaspsedTimes(4) + PostRetTime;
ExpectedWithinTrialElaspsedTimes(6,1) = ExpectedWithinTrialElaspsedTimes(5) + ProbeTime;
TotalTrialTime = ExpectedWithinTrialElaspsedTimes(6,1);
% --------------------------------------------------------
% Select type of ITI
% --------------------------------------------------------
ITIValue = -1;
if ITIValue > 0
    ITI = ones(NTrials,1)*ITIValue;
    ExpectedMeanITI = ITIValue+0.2;
else
    %ITI = subfnCreateITI(NTrials);
    %ITI = randn(NTrials,1)+15;
    ITI = randg(ones(NTrials,1))*2;
    ExpectedMeanITI = mean(ITI);
    
end
% --------------------------------------------------------
% Set End delay
% --------------------------------------------------------
% The end period will be set based on the expected ITI values and the number of
% trials.
ActualDuration = NTrials*TotalTrialTime + sum(ITI(1:NTrials));
ExpectedDuration = NTrials*(TotalTrialTime + ExpectedMeanITI);
% Check to make sure that the ITI parameters were not changed without
% changing the expectedMeanITI
if ExpectedDuration < ActualDuration
    error('The ITI distributions need to be fixed!');
end
EndDelay = ExpectedDuration - ActualDuration;
%%
ShapeValues = [1:0.5:6];
ScaleValues = [1:0.5:6];
NShape = length(ShapeValues);
NScale = length(ScaleValues);
NRuns = 10;
SumEff = zeros(NShape,NScale,NRuns,2);
SumBE = zeros(NShape,NScale,NRuns,2);


for kk = 1:NShape%
    for mm = 1:NScale
        ITI = gamrnd(ShapeValues(kk),ScaleValues(mm),NTrials,1);
        ExpectedMeanITI = mean(ITI);
        
        
        
        for jj = 1:NRuns % different ordering of the design with the same ITI distribution
            NRepeats = 2;
            NumberListLength = 4;
            LoadLevels= [2 6];
            [Trials Design] = subfnCreateDesign(NRepeats,NumberListLength, LoadLevels);
            
            
            
            %NTrials = length(Trials);
            
            
            
            % Create ExperimentParameters structure
            
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
            subid = 'TEST';
            FileName = fullfile(DesignDir,[subid '_DesignSPM' '.mat']);
            str = ['save ' FileName ' names durations onsets'];
            eval(str)
            Input = load(FileName);
            TR = 2;
            hpf = 128;
            
            %job = subfnCreateDesignJob(FileName, TR, hpf);
            
            P = fullfile(DesignDir,'BlankSPMDesignJob');
            load(P)
            
            delete(fullfile(DesignDir,'SPM.mat'));
            
            matlabbatch{1}.spm.stats.fmri_design.dir = {DesignDir};
            matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
            matlabbatch{1}.spm.stats.fmri_design.timing.RT = TR;
            
            matlabbatch{1}.spm.stats.fmri_design.sess.nscan = 300;
            matlabbatch{1}.spm.stats.fmri_design.sess.multi = {FileName};
            spm_jobman('run',matlabbatch)
            
            load SPM
            % figure(10)
            % imagesc(SPM.xX.X)
            
            [m n] = size(SPM.xX.X);
            [SPM] = subfnCreateContrats_iLS(SPM);
            [eff VRF BoldEffect] = subfnCalcModelEfficiency_iLS(SPM);
            NCon = length(SPM.xCon);
            SumEff(kk,mm,jj,1)=sum(eff([7 8 9 10 11 18 19 20 21 22]));
            SumEff(kk,mm,jj,2)=sum(eff);
            SumBE(kk,mm,jj,1) = sum(BoldEffect([7 8 9 10 11 18 19 20 21 22]));
            SumBE(kk,mm,jj,2)=sum(BoldEffect);
            %SumEff(jj) = sum(eff);
        end
    end
end
%%
% Plot Effeciciency
    figure(12)
    hist(SumEff(:,:,1))
    %
    figure(11)
    clf
    for i = 1:NCon
        subplot(NCon+8,2,(i-1)*2+1:i*2)
        C = SPM.xCon(i).c;
        C = [C zeros(1,n-length(C))];
        bar(C)
        axis off
        text(-1,1,SPM.xCon(i).name)
        text(12,1,num2str(eff(i)))
    end
    subplot(NCon+8,2,NCon*2+1:NCon*2+16)
    imagesc(SPM.xX.X)
    xlabel(num2str(sum(eff)))

    % Plot Effeciciency
    figure(13)
    clf
    for i = 1:NCon
        subplot(NCon+8,2,(i-1)*2+1:i*2)
        C = SPM.xCon(i).c;
        C = [C zeros(1,n-length(C))];
        bar(C)
        axis off
        text(-1,1,SPM.xCon(i).name)
        text(12,1,num2str(BoldEffect(i)))
    end
    subplot(NCon+8,2,NCon*2+1:NCon*2+16)
    imagesc(SPM.xX.X)
    xlabel(num2str(sum(BoldEffect)))

    