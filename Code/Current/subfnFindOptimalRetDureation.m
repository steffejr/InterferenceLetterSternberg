NScan = 313;

DurTimes = [3 7 -1 3];
[names onsets durations] = CreateSPMRegressors(Trials,DurTimes)

 subid = 'TEST';
            FileName = fullfile(DesignDir,[subid '_DesignSPM' '.mat']);
            str = ['save ' FileName ' names durations onsets'];
            eval(str)
            Input = load(FileName);
            TR = 2;
            hpf = 128;
            
            %job = subfnCreateDesignJob(FileName, TR, hpf);
            
            P = fullfile(DesignDir,'BlankDesignJob');
            load(P)
            
            delete(fullfile(DesignDir,'SPM.mat'));
            
            matlabbatch{1}.spm.stats.fmri_design.dir = {DesignDir};
            matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
            matlabbatch{1}.spm.stats.fmri_design.timing.RT = TR;
            
            matlabbatch{1}.spm.stats.fmri_design.sess.nscan = NScan;
            matlabbatch{1}.spm.stats.fmri_design.sess.multi = {FileName};
            spm_jobman('run',matlabbatch)
            
            load SPM
            
             [m n] = size(SPM.xX.X);
            [SPM] = subfnCreateContrats_LS(SPM);
            [eff VRF BoldEffect] = subfnCalcModelEfficiency_iLS(SPM);
