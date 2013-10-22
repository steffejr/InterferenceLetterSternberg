% concatenate the runs and calculate the summary stats across all runs.

BasePath = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\Results\New folder';
%BasePath = 'C:\Users\Makaye\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LEtterSternbergWithInterference\Results';
F = dir(fullfile(BasePath,'*.mat'));
% The problem is that
% List of files to check
FileList = 1:length(F);
WriteHeaderFlag = 1;
fid = 1;
for i = 1:length(F)
    if FileList(i)
        UnderScores = findstr(F(i).name,'_');
        subid = F(i).name(UnderScores(1)+1:UnderScores(2)-1);
        %F2 = dir(fullfile(BasePath,['iLS_' subid '_*_*']));
        F3 = dir(fullfile(BasePath,['iLS_' subid '*Instr1*FB1*']));
        TrainCount = 1;
        % find the first training with instructions
        
        for j = 1:length(F3)
            for kk = 1:length(F)
                if strmatch(F3(j).name, F(kk).name)
                    % has this file been checked already?
                    if FileList(kk)
                        Tag = ['Train' num2str(TrainCount)];
                        TrainCount = TrainCount + 1;
                        TempName = F3(j).name;
                        Fsubid = findstr(TempName,subid)
                        Funder = findstr(TempName,'_');
                        Funder = Funder(min(find((Funder > Fsubid(1)))))
                        
                        NewName = [TempName(1:Funder) Tag '_' TempName(Funder+1:end)];
                        movefile(fullfile(BasePath,TempName),fullfile(BasePath,NewName));
                        FileList(kk) = 0;
                    end
                    
                end
            end
        end
        % find the training with no instructions
        F4 = dir(fullfile(BasePath,['iLS_' subid '*Instr0**FB1*']));
        
        for j = 1:length(F4)
            for kk = 1:length(F)
                if strmatch(F4(j).name, F(kk).name)
                    % has this file been checked already?
                    if FileList(kk)
                        Tag = ['Train' num2str(TrainCount)];
                        TrainCount = TrainCount + 1;
                        TempName = F4(j).name;
                        Fsubid = findstr(TempName,subid)
                        Funder = findstr(TempName,'_');
                        Funder = Funder(min(find((Funder > Fsubid(1)))))
                        
                        NewName = [TempName(1:Funder) Tag '_' TempName(Funder+1:end)];
                        movefile(fullfile(BasePath,TempName),fullfile(BasePath,NewName));
                        FileList(kk) = 0;
                    end
                end
            end
        end
        
        F5 = dir(fullfile(BasePath,['iLS_' subid '*Instr0**FB0*']));
        % if only 3 then assume these are the three MRI Runs, if 4
        % assume first is the last training
        
        if length(F5) == 4
            for kk = 1:length(F)
                j = 1;
                if strmatch(F5(j).name, F(kk).name)
                    % has this file been checked already?
                    if FileList(kk)
                        
                        
                        Tag = ['Train' num2str(TrainCount)];
                        TrainCount = TrainCount + 1;
                        TempName = F5(j).name;
                        Fsubid = findstr(TempName,subid)
                        Funder = findstr(TempName,'_');
                        Funder = Funder(min(find((Funder > Fsubid(1)))))
                        NewName = [TempName(1:Funder) Tag '_' TempName(Funder+1:end)];
                        movefile(fullfile(BasePath,TempName),fullfile(BasePath,NewName));
                        FileList(kk) = 0;
                    end
                end
            end
            MRICount = 1;
            for j = 2:4
                for kk = 1:length(F)
                    if strmatch(F5(j).name, F(kk).name)
                        % has this file been checked already?
                        if FileList(kk)
                            Tag = ['MRI' num2str(MRICount)];
                            MRICount = MRICount + 1;
                            TempName = F5(j).name;
                            Fsubid = findstr(TempName,subid)
                            Funder = findstr(TempName,'_');
                            Funder = Funder(min(find((Funder > Fsubid(1)))))
                            NewName = [TempName(1:Funder) Tag '_' TempName(Funder+1:end)];
                            movefile(fullfile(BasePath,TempName),fullfile(BasePath,NewName));
                            FileList(kk) = 0;
                        end
                    end
                end
            end
        elseif length(F5) == 3
            MRICount = 1;
            for j = 1:3
                for kk = 1:length(F)
                    if strmatch(F5(j).name, F(kk).name)
                        % has this file been checked already?
                        if FileList(kk)
                            Tag = ['MRI' num2str(MRICount)];
                            MRICount = MRICount + 1;
                            TempName = F5(j).name;
                            Fsubid = findstr(TempName,subid)
                            Funder = findstr(TempName,'_');
                            Funder = Funder(min(find((Funder > Fsubid(1)))))
                            NewName = [TempName(1:Funder) Tag '_' TempName(Funder+1:end)];
                            movefile(fullfile(BasePath,TempName),fullfile(BasePath,NewName));
                            FileList(kk) = 0;
                        end
                    end
                end
            end
        end
    end
end












