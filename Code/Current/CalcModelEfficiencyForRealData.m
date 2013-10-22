SPMBaseDir = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\SPMDesign';
ResultsBaseDir = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\Results\Include';



F = dir(fullfile(ResultsBaseDir,'*.mat'));
% The problem is that
% List of files to check
FileList = 1:length(F);
NScan = 270;
for i = 1:length(F)
    if FileList(i)
        %if isempty(findstr('FB1',F(i).name)) & isempty(findstr('Instr1',F(i).name)) & isempty(findstr('NumList0',F(i).name))
        if strfind(F(i).name,'MRI') 
        % if a "good" file is found, then find all files from that same
            % person
            UnderScores = findstr(F(i).name,'_');
            subid = F(i).name(UnderScores(1)+1:UnderScores(2)-1);
            F2 = dir(fullfile(ResultsBaseDir,['iLS_' subid '*MRI*']));
            % Determine the order of the runs
            TempList = F2;
            %         CurrentFile = F2(1).name;
            %         FirstFile = CurrentFile;
            %         UnderScores = findstr(FirstFile,'_');
            %         TimeOfFile = CurrentFile(UnderScores(4)+1:UnderScores(5)-1);
            %         DateOfFile = CurrentFile(UnderScores(3)+1:UnderScores(4)-1);
            %         CurrentDate = str2num([DateOfFile TimeOfFile]);
            Dates = [];
            Tags = {};
            for j = 1:length(F2)
                
                % Find the file in the master list
                for kk = 1:length(F)
                    if strmatch(F2(j).name, F(kk).name)
                        % has this file been checked already?
                        if FileList(kk)
                            
                            CurrentFile = F2(j).name;
                            UnderScores = findstr(CurrentFile,'_');
                            TimeOfFile = CurrentFile(UnderScores(4)+1:UnderScores(5)-1);
                            DateOfFile = CurrentFile(UnderScores(3)+1:UnderScores(4)-1);
                            CurrentDate = str2num([DateOfFile TimeOfFile]);
                            Dates = [Dates; CurrentDate];
                            Tags{length(Tags)+1} = CurrentFile(UnderScores(2)+1:UnderScores(3)-1);
                            % remove the file from the master list
                            FileList(kk) = 0;
                            
                        end
                    end
                end
            end
            % reorder the runs
            [s I] = sort(Dates);
            F2 = F2(I);
            Results = {}; 
            clear matlabbatch
            load(fullfile(SPMBaseDir,'BlankSPMDesignJob.mat'));
            matlabbatch{1}.spm.stats.fmri_design.dir = {SPMBaseDir};
            for j = 1:length(F2)
                EP = load(fullfile(ResultsBaseDir,F2(j).name));
                [names onsets durations] = CreateSPMRegressors(EP.ExperimentParameters.Trials);
                OutFile = fullfile(SPMBaseDir,[subid '_' Tags{j} '.mat']);
                Str = ['save ' OutFile ' names onsets durations'];
                eval(Str);
                matlabbatch{1}.spm.stats.fmri_design.sess(j).nscan = NScan;
                matlabbatch{1}.spm.stats.fmri_design.sess(j).multi{1} = OutFile;
            end
            % IF EXISTS DELETE THE SPM.mat FILE
            delete(fullfile(fullfile(SPMBaseDir,'SPM.mat')))
            spm_jobman('run',matlabbatch);
            % Load the file
            load(fullfile(SPMBaseDir,'SPM.mat'))
            [SPM] = subfnCreateContrats_iLS_3Sess(SPM)
            [eff VRF BoldEffect] = subfnCalcModelEfficiency_iLS(SPM);
            subfn_PlotEffOfOneSubject(SPM,eff,BoldEffect)
        end
        
       
        
    end

