function [SPM] = subfnCreateContrats_iLS(SPM)
BaseDir = 'C:\Users\jsteffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LetterSternbergWithInterference';
ResultsDir = fullfile(BaseDir,'Results');
DesignDir = fullfile(BaseDir,'SPMDesign');

% Create the Contrasts
count = 0;
count = count + 1;
Contrast{count}.name = 'iStm';
Contrast{count}.c = [1 1];
count = count + 1;
Contrast{count}.name = 'iRet';
Contrast{count}.c = [0 0 1 1 1 1];
count = count + 1;
Contrast{count}.name = 'iRetLow';
Contrast{count}.c = [0 0 1 0 1 0];
count = count + 1;
Contrast{count}.name = 'iRetHigh';
Contrast{count}.c = [0 0 0 1 0 1];
count = count + 1;
Contrast{count}.name = 'iRet2';
Contrast{count}.c = [0 0 1 1];
count = count + 1;
Contrast{count}.name = 'iRet6';
Contrast{count}.c = [0 0 0 0 1 1];
count = count + 1;
Contrast{count}.name = 'iPro';
Contrast{count}.c = [0 0 0 0 0 0 1 1 1 1];
count = count + 1;
Contrast{count}.name = 'iProLow';
Contrast{count}.c = [0 0 0 0 0 0 1 0 1 0];
count = count + 1;
Contrast{count}.name = 'iProHigh';
Contrast{count}.c = [0 0 0 0 0 0 0 1 0 1];
count = count + 1;
Contrast{count}.name = 'iPro2';
Contrast{count}.c = [0 0 0 0 0 0 1 1];
count = count + 1;
Contrast{count}.name = 'iPro6';
Contrast{count}.c = [0 0 0 0 0 0 0 0 1 1];

count = count + 1;
Contrast{count}.name = 'sStm';
Contrast{count}.c = [-1 1];
count = count + 1;
Contrast{count}.name = 'sRet';
Contrast{count}.c = [0 0 -1 -1 1 1];
count = count + 1;
Contrast{count}.name = 'sRetLow';
Contrast{count}.c = [0 0 -1 0 1];
count = count + 1;
Contrast{count}.name = 'sRetHigh';
Contrast{count}.c = [0 0 0 -1 0 1];
count = count + 1;
Contrast{count}.name = 'sRet2';
Contrast{count}.c = [0 0 -1 1];
count = count + 1;
Contrast{count}.name = 'sRet6';
Contrast{count}.c = [0 0 0 0 -1 1];
count = count + 1;
Contrast{count}.name = 'sPro';
Contrast{count}.c = [0 0 0 0 0 0 -1 -1 1 1];
count = count + 1;
Contrast{count}.name = 'sProLow';
Contrast{count}.c = [0 0 0 0 0 0 -1 0 1];
count = count + 1;
Contrast{count}.name = 'sProHigh';
Contrast{count}.c = [0 0 0 0 0 0 0 -1 0 1];
count = count + 1;
Contrast{count}.name = 'sPro2';
Contrast{count}.c = [0 0 0 0 0 0 -1 1];
count = count + 1;
Contrast{count}.name = 'sPro6';
Contrast{count}.c = [0 0 0 0 0 0 0 0 -1 1];




SPM.xCon = {};

NCon = length(Contrast);
for i = 1:NCon
    SPM.xCon(i).STAT = 'T';
    SPM.xCon(i).name = Contrast{i}.name;
    SPM.xCon(i).c = Contrast{i}.c;

end

    