conn = database('iLS', '', '');
% Select ONE Result file for a subject and display all of their results.
ResultsFolder = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\Results'
cd(ResultsFolder)
AllFiles = dir('iLS*.mat')
for i = 1:length(AllFiles)
    D = fullfile(ResultsFolder,AllFiles(i).name);
    clear ExperimentParameters
    load(D);
     % Need to recalculate the Results
    [Trials Results] = subfnCorrectResponses(ExperimentParameters);
    ExperimentParameters.Trials = Trials;
    ExperimentParameters.Results = Results;
    str = ['save ' D ' ExperimentParameters'];
    eval(str)
    [PathName, FileName] = fileparts(D);
    % find the subject ID
    FindUnder = findstr(FileName,'_');
    subid = FileName(FindUnder(1)+1 : FindUnder(2)-1);
    rundate = FileName(FindUnder(2)+1:FindUnder(3)-1);
    rundate = ['20' rundate(5:6) '-' rundate(1:2) '-' rundate(3:4)];
    runtime = FileName(FindUnder(3)+1:FindUnder(4)-1);
    runtime = [runtime(1:2) ':' runtime(3:4)];
    
    visitid = '1';
    visittype = 'pilot';
    % Check to see if this person is already in teh database
    str = ['select count(*) from AllData where (subid = ''' subid ''' and rundate = ''' rundate ''' and runtime = ''' runtime ''' );']
    setdbprefs('DataReturnFormat','numeric');
    curs = exec(conn, str);
    if length(curs.Message);error(curs.Message);end
    curs = fetch(curs, 10);
    Count = curs.Data;
    if ~Count
        str = ['insert into AllData (subid, visitid, rundate,runtime,visittype) values (''' subid ''', ''' visitid ''', ''' rundate ''', ''' runtime ''', '''  visittype ''');'];
        curs = exec(conn, str);
        if length(curs.Message);error(curs.Message);end
        
        NewPersonFlag = 'TRUE';
    else
        NewPersonFlag = 'FALSE';
    end
    
    if ~isempty(strmatch(NewPersonFlag, 'TRUE'))
        % Enter age and sex information
        if isfield(ExperimentParameters,'Age')
            str = sprintf('update AllData set age = ''%s'' where (subid=''%s'' and runtime=''%s'');',ExperimentParameters.Age,subid,runtime);
            curs = exec(conn, str);
        end
        if isfield(ExperimentParameters,'Sex')
            str = sprintf('update AllData set sex = ''%s'' where (subid=''%s'' and runtime=''%s'');',ExperimentParameters.Sex,subid,runtime);
            curs = exec(conn, str);
        end
        str = sprintf('update AllData set Instr = ''%d'' where (subid=''%s'' and runtime=''%s'');',ExperimentParameters.RunConditions.PresentInstructionsFlag,subid,runtime);
        curs = exec(conn, str);
        if length(curs.Message);error(curs.Message);end
        str = sprintf('update AllData set FB = ''%d'' where (subid=''%s'' and runtime=''%s'');',ExperimentParameters.RunConditions.FeedbackFlag,subid,runtime);
        curs = exec(conn, str);
        if length(curs.Message);error(curs.Message);end
        str = sprintf('update AllData set NNum = ''%d'' where (subid=''%s'' and runtime=''%s'');',ExperimentParameters.RunConditions.NumberListLength,subid,runtime);
        curs = exec(conn, str);
        if length(curs.Message);error(curs.Message);end
        str = sprintf('update AllData set NRepeats = ''%d'' where (subid=''%s'' and runtime=''%s'');',ExperimentParameters.RunConditions.NRepeats,subid,runtime);
        curs = exec(conn, str);
        if length(curs.Message);error(curs.Message);end
        
        str = sprintf('update AllData set NTrials = ''%d'' where (subid=''%s'' and runtime=''%s'');',length(ExperimentParameters.Trials),subid,runtime);
        curs = exec(conn, str);
        if length(curs.Message);error(curs.Message);end
        
        ResultsColumns = [1 2 6 99];
        for k = 1:length(ResultsColumns)
            if ~isempty(ExperimentParameters.Results{ResultsColumns(k)})
                if k < 4
                    
                    F = fieldnames(ExperimentParameters.Results{ResultsColumns(k)});
                    Fnew = F;
                    for j = 1:length(F)
                        Fnew{j} = [num2str(ResultsColumns(k)) 'Let' Fnew{j}(7:end)];
                    end
                else
                    F = fieldnames(ExperimentParameters.Results{ResultsColumns(k)});
                    Fnew = F;
                end
                for j = 1:length(F)
                    % Use the following only to setup the table
                    %str = sprintf('alter table AllData add %s FLOAT NOT NULL',Fnew{j});
                    %curs = exec(conn, str);
                    %if length(curs.Message);error(curs.Message);end
                    
                    %            OutputString = [OutputString sprintf('%-70s\t%0.3f\n',F{j},eval(['ExperimentParameters.Results{' num2str(ResultsColumns(k)) '}.' F{j}]))];
                    str = sprintf('update AllData set %s = ''%d'' where (subid=''%s'' and runtime=''%s'');',Fnew{j},eval(['ExperimentParameters.Results{' num2str(ResultsColumns(k)) '}.' F{j}]),subid,runtime);
                    curs = exec(conn, str);
                    if length(curs.Message);error(curs.Message);end
                end
            end
        end
        
    end
    
end