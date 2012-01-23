% Select folder of results
% Do you want Training data or test data
% for each subject load the Experiment Parameter files
% create table of run specific summary measures
% concatenate the runs and calculate the summary stats across all runs.

%BasePath = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\Results\Include';
BasePath = uigetdir('','Select Directory of Results');
%BasePath = 'C:\Users\Makaye\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LEtterSternbergWithInterference\Results';
F = dir(fullfile(BasePath,'*.mat'));
% The problem is that
% List of files to check
FileList = 1:length(F);
WriteHeaderFlag = 1;
%fid = 1;
c = clock;
OutFileName = fullfile(BasePath,['iLS_Results_' date '_' num2str(c(4)) '-' num2str(c(5)) '.csv']);
fid = fopen(OutFileName,'w');
%fid = 1;
LetLoadMap = {};
LetLoadMap{1} = 'One';
LetLoadMap{2} = 'Two';
LetLoadMap{3} = 'Three';
LetLoadMap{4} = 'Four';
LetLoadMap{5} = 'Five';
LetLoadMap{6} = 'Six';

for i = 1:length(F)
    if FileList(i)
        %if isempty(findstr('FB1',F(i).name)) & isempty(findstr('Instr1',F(i).name)) & isempty(findstr('NumList0',F(i).name))
        if findstr(F(i).name,'MRI') 
        % if a "good" file is found, then find all files from that same
            % person
            UnderScores = findstr(F(i).name,'_');
            subid = F(i).name(UnderScores(1)+1:UnderScores(2)-1);
            F2 = dir(fullfile(BasePath,['iLS_' subid '*MRI*']));
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
            EP = {};
            Results = {};
            for j = 1:length(F2)
                EP{j} = load(fullfile(BasePath,F2(j).name));
                [Trials Results{j}] = subfnCorrectResponses_LetNum(EP);
            end
            % Concatenate trials
            [Trials AllResults] = subfnCorrectResponses_LetNum(EP);
            %% write out results calculated from all runs
            
            % Write out HEADER
            if WriteHeaderFlag
            Tag = '';
            fprintf(fid,'%s,','subid');
            fprintf(fid,'%s,','date');
            fprintf(fid,'%s,','time');
            fprintf(fid,'%s,','sex');
            fprintf(fid,'%s,','dob');
            fprintf(fid,'%s,','age');
            
            for kk = 1:length(AllResults)
                if ~isempty(AllResults{kk})
                    FNames = fieldnames(AllResults{kk});
                    for m = 1:length(FNames)
                        if kk < 99
                            fprintf(fid,'%s%s,',LetLoadMap{kk},FNames{m});
                            % fprintf(fid,'%0.4f,',eval(['AllResults{' num2str(kk) '}.' FNames{m}]));
                        else
                            fprintf(fid,'%s,',FNames{m});
                            
                        end
                    end
                end
            end
            for k = 1:length(Results)
                % Find the TAG
                Tag = Tags{I(k)};
                for kk = 1:length(Results{k})
                    if ~isempty(Results{k}{kk})
                        FNames = fieldnames(Results{k}{kk});
                        for m = 1:length(FNames)
                            if kk < 99
                                fprintf(fid,'%s_%d%s,',Tag,kk,FNames{m});
                            else
                                fprintf(fid,'%s_%s,',Tag,FNames{m});
                            end
                        end
                    end
                end
            end
            fprintf(fid,'\n');
            WriteHeaderFlag = 0;
            end
            fprintf(fid,'%s,',subid);
            FindUnders = strfind(EP{1}.ExperimentParameters.date,'_');
            if ~isfield(EP{1}.ExperimentParameters,'Sex')
                EP{1}.ExperimentParameters.Sex = '-1';
            end
            if ~isfield(EP{1}.ExperimentParameters,'dob')
                EP{1}.ExperimentParameters.dob = '-1';
            end
            if ~isfield(EP{1}.ExperimentParameters,'Age')
                EP{1}.ExperimentParameters.Age = '-1';
            end
            fprintf(fid,'%s,',EP{1}.ExperimentParameters.date(1:FindUnders-1));
            fprintf(fid,'%s,',EP{1}.ExperimentParameters.date(FindUnders+1:end));
            fprintf(fid,'%s,',EP{1}.ExperimentParameters.Sex);
            fprintf(fid,'%s,',EP{1}.ExperimentParameters.dob);
            fprintf(fid,'%s,',EP{1}.ExperimentParameters.Age);
            
            for kk = 1:length(AllResults)
                if ~isempty(AllResults{kk})
                    FNames = fieldnames(AllResults{kk});
                    for m = 1:length(FNames)
                        if kk < 99
                            %fprintf(fid,'%s_%d%s,',Tag,kk,FNames{m});
                            fprintf(fid,'%0.4f,',eval(['AllResults{' num2str(kk) '}.' FNames{m}]));
                        else
                            %                         fprintf(fid,'%s_%s,',Tag,FNames{m});
                            fprintf(fid,'%0.4f,',eval(['AllResults{' num2str(kk) '}.' FNames{m}]));
                        end
                    end
                end
            end
            for k = 1:length(Results)
                % Find the TAG
                Tag = Tags{I(k)};
                for kk = 1:length(Results{k})
                    if ~isempty(Results{k}{kk})
                        FNames = fieldnames(Results{k}{kk});
                        for m = 1:length(FNames)
                            if kk < 99
                                %                             fprintf(fid,'%s_%d%s,',Tag,kk,FNames{m});
                                fprintf(fid,'%0.4f,',eval(['AllResults{' num2str(kk) '}.' FNames{m}]));
                            else
                                %                             fprintf(fid,'%s_%s,',Tag,FNames{m});
                                fprintf(fid,'%0.4f,',eval(['AllResults{' num2str(kk) '}.' FNames{m}]));
                            end
                        end
                    end
                end
            end
            fprintf(fid,'\n');
        end
    end
end
fprintf(1,'\nResults printed to:\n\t%s\n\n',OutFileName)
fclose(fid);
