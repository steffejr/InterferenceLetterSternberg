function subfnDisplayAllResults(Tag)
% Select ONE Result file for a subject and display all of their results.
[FileName PathName] = uigetfile('iLS*.mat','Select one file from a subject');
cd(PathName)
% find the subject ID
FindUnder = findstr(FileName,'_');
subid = FileName(FindUnder(1)+1 : FindUnder(2)-1);
rundate = FileName(FindUnder(3)+1:FindUnder(4)-1);
rundate = ['20' rundate(5:6) '-' rundate(1:2) '-' rundate(3:4)];
runtime = FileName(FindUnder(4)+1:FindUnder(5)-1);
runtime = [runtime(1:2) ':' runtime(3:4)];

visitid = '1';
visittype = 'pilot'
% Check to see if this person is already in teh database
% str = ['select count(*) from AllData where (subid = ''' subid ''' and rundate = ''' rundate ''' and runtime = ''' runtime ''' );']
% setdbprefs('DataReturnFormat','numeric')
% curs = exec(conn, str)
% curs = fetch(curs, 10);
% Count = curs.Data
% if ~Count 
%     str = ['insert into AllData (subid, visitid, rundate,runtime,visittype) values (''' subid ''', ''' visitid ''', ''' rundate ''', ''' runtime ''', '''  visittype ''');']
%     curs = exec(conn, str);
%     curs.Message
%     NewPersonFlag = 'TRUE'
% else
%     NewPersonFlag = 'FALSE'
% end



% find all files from the same subject
D = dir(['iLS_' subid '*' Tag '*.mat']);
% cycle over the files and display the results
ResultsColumns = [2 6 99];
OutputString = '';

for i = 1:length(D)
    clear ExperimentParameters
    load(D(i).name);
    OutputString = [OutputString sprintf('========================================================\n',subid,i)];
    OutputString = [OutputString sprintf('------------- %s - run %d -------------\n',subid,i)];
    for k = 1:length(ResultsColumns)
        if ResultsColumns(k) == 99
            OutputString = [OutputString sprintf('---------- Results: Numbers ----------\n')];
        else
            OutputString = [OutputString sprintf('---------- Results: Letters %d ----------\n',ResultsColumns(k))];
        end
        F = fieldnames(ExperimentParameters.Results{ResultsColumns(k)});
        for j = 1:length(F)
            OutputString = [OutputString sprintf('%-70s\t%0.3f\n',F{j},eval(['ExperimentParameters.Results{' num2str(ResultsColumns(k)) '}.' F{j}]))];
        end
        
    end
end
%fprintf(1,'%s\n',OutputString);
% m = msgbox(OutputString);
% set(m,'Position',[657 505.5 125.25 52.5],'Resize','on')


 h = figure;
 set(h,'Position',[100 100 450 400])
h2 = uicontrol('Parent',h,...
          'Units','normalized',...
          'Position',[0.1,0.1,0.9,0.8],...
          'Style','edit',...
          'Max',100,...
          'Enable','inactive',...
          'String',OutputString,...
      'HorizontalAlignment','left')
