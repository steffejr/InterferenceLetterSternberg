
LoadLevels = [1  3  5  7  9];
NumberListLength = 0;
NRepeats = 3;



%% Read Config File
s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);

[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Modified_Config.txt'));
%%
[Trials Design] = subfnCreateDesign(NRepeats,NumberListLength, LoadLevels, handles);

