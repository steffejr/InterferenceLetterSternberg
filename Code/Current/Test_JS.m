
s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);

%[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config.txt'),handles);
%[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config.txt'),handles);
[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config_Columbia.txt'));
Instr = 0;
FB = 0;
NRepeats = 5;
NumberListLength = 0;
demog = {};
demog.subid = '1234';
demog.Tag = 'Run1';
LoadLevels = [1 3 6];
subfnLetterSternbergWithInterference_Test(demog,  Instr,FB,NumberListLength,NRepeats,LoadLevels,handles)

