% Select folder of results
% Do you want Training data or test data
% for each subject load the Experiment Parameter files
% create table of run specific summary measures
% concatenate the runs and calculate the summary stats across all runs.


LetLoadMap = {};
LetLoadMap{1} = 'One';
LetLoadMap{2} = 'Two';
LetLoadMap{3} = 'Three';
LetLoadMap{4} = 'Four';
LetLoadMap{5} = 'Five';
LetLoadMap{6} = 'Six';
%BasePath = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\Results\Include';
BasePath = uigetdir('','Select Directory of Results');
%%
fid = 1;
c = clock;
OutFileName = fullfile(BasePath,['iLS_Results_' date '_' num2str(c(4)) '-' num2str(c(5)) '.csv']);
%fid = fopen(OutFileName,'w');

WriteHeaderFlag = 1;
% In this directory find all the subject folders;
SubFolders = dir(fullfile(BasePath,'iLS_*'));
% enter each subject folder
for j = 1:length(SubFolders)
    % find the mat files
    try
        F2 = dir(fullfile(BasePath,SubFolders(j).name,'iLS*_MRI*NumList4.mat'));
        Results = {};
        Dates = [];
        Tags = {};
        EP = {};
        for i = 1:length(F2)
            %if isempty(findstr('FB1',F(i).name)) & isempty(findstr('Instr1',F(i).name)) & isempty(findstr('NumList0',F(i).name))
            %if findstr(F2(i).name,'MRI')
            % if a "good" file is found, then find all files from that same
            % person
            UnderScores = findstr(F2(i).name,'_');
            subid = F2(i).name(UnderScores(1)+1:UnderScores(2)-1);
            
            % Determine the order of the runs
            TempList = F2;
            
            CurrentFile = F2(i).name;
            UnderScores = findstr(CurrentFile,'_');
            TimeOfFile = CurrentFile(UnderScores(end-3)+1:UnderScores(end-2)-1);
            DateOfFile = CurrentFile(UnderScores(end-4)+1:UnderScores(end-3)-1);
            CurrentDate = str2num([DateOfFile TimeOfFile]);
            Dates = [Dates; CurrentDate];
            Tags{length(Tags)+1} = CurrentFile(UnderScores(end-5)+1:UnderScores(end-4)-1);
            % remove the file from the master list
            EP{i} = load(fullfile(BasePath,SubFolders(j).name,F2(i).name));
            %[Trials Results{i}] = subfnCorrectResponses_LetNum(EP{i}.ExperimentParameters);
        end
        % Concatenate trials
        [Trials AllResults] = subfnCorrectResponses_LetNum(EP);
        % end
        
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
            %                 for k = 1:length(Results)
            %                     % Find the TAG
            %                     Tag = Tags{I(k)};
            %                     for kk = 1:length(Results{k})
            %                         if ~isempty(Results{k}{kk})
            %                             FNames = fieldnames(Results{k}{kk});
            %                             for m = 1:length(FNames)
            %                                 if kk < 99
            %                                     fprintf(fid,'%s_%d%s,',Tag,kk,FNames{m});
            %                                 else
            %                                     fprintf(fid,'%s_%s,',Tag,FNames{m});
            %                                 end
            %                             end
            %                         end
            %                     end
            %                 end
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
        %             for k = 1:length(Results)
        %                 % Find the TAG
        %                 Tag = Tags{I(k)};
        %                 for kk = 1:length(Results{k})
        %                     if ~isempty(Results{k}{kk})
        %                         FNames = fieldnames(Results{k}{kk});
        %                         for m = 1:length(FNames)
        %                             if kk < 99
        %                                 %                             fprintf(fid,'%s_%d%s,',Tag,kk,FNames{m});
        %                                 fprintf(fid,'%0.4f,',eval(['AllResults{' num2str(kk) '}.' FNames{m}]));
        %                             else
        %                                 %                             fprintf(fid,'%s_%s,',Tag,FNames{m});
        %                                 fprintf(fid,'%0.4f,',eval(['AllResults{' num2str(kk) '}.' FNames{m}]));
        %                             end
        %                         end
        %                     end
        %                 end
        %             end
        fprintf(fid,'\n');
    catch me
        me
    end
end
    
    fprintf(1,'\nResults printed to:\n\t%s\n\n',OutFileName)
    fclose(fid);
