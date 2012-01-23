function [SPM] = subfnCreateContrats_iLS(SPM)
BaseDir = 'C:\Users\jsteffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LetterSternbergWithInterference';
ResultsDir = fullfile(BaseDir,'Results');
DesignDir = fullfile(BaseDir,'SPMDesign');


NSess = length(SPM.Sess);
[m n] = size(SPM.xX.X);
BlankContrast = zeros(1,n);
% Create the Contrasts
count = 0;
count = count + 1;
Contrast{count}.name = 'iStm';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([1 2])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iRet';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([3:6])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iRetLow';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([3 5])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iRetHigh';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([4 6])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iRet2';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([3 4])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iRet6';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([5 6])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iPro';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([7:10])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iProLow';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([7 9])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iProHigh';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([8 10])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iPro2';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([7 8])) = 1;
end

count = count + 1;
Contrast{count}.name = 'iPro6';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([9 10])) = 1;
end

count = count + 1;
Contrast{count}.name = 'sStm';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([1 2])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sRet';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([3:6])) = [-1 -1 1 1];
end

count = count + 1;
Contrast{count}.name = 'sRetLow';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([3 5])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sRetHigh';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([4 6])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sRet2';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([3 4])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sRet6';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([5 6])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sPro';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([7:10])) = [-1 -1 1 1];
end

count = count + 1;
Contrast{count}.name = 'sProLow';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([7 9])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sProHigh';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([8 10])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sPro2';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([7 8])) = [-1 1];
end

count = count + 1;
Contrast{count}.name = 'sPro6';
Contrast{count}.c = BlankContrast;
for i = 1:NSess
    Contrast{count}.c(SPM.Sess(i).col([9 10])) = [-1 1];
end


SPM.xCon = {};

NCon = length(Contrast);
for i = 1:NCon
    SPM.xCon(i).STAT = 'T';
    SPM.xCon(i).name = Contrast{i}.name;
    SPM.xCon(i).c = Contrast{i}.c;

end

    