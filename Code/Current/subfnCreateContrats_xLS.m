function [SPM] = subfnCreateContrats_xLS(SPM,LoadLevels)
BaseDir = 'C:\Users\jsteffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LetterSternbergWithInterference';
ResultsDir = fullfile(BaseDir,'Results');
DesignDir = fullfile(BaseDir,'SPMDesign');

NSess = length(SPM.Sess);
X = [LoadLevels;ones(length(LoadLevels),1)']';

X(:,1) = X(:,1) - mean(X(:,1));
oX = orth(X);
% Create the Contrasts
Contrast = {};

for i = 1:length(LoadLevels)
    Z = zeros(1,length(LoadLevels));
    Z(i) = 1;
    Contrast{i}.name = sprintf('Load_%d',i);
    Contrast{i}.c = repmat(Z,1,NSess);
end

    

% count = 0;
% count = count + 1;
% Contrast{count}.name = 'iStm';
% Contrast{count}.c = [oX(:,2)'];
% count = count + 1;
% Contrast{count}.name = 'iRet';
% Contrast{count}.c = [zeros(length(LoadLevels),1)' oX(:,2)'];
% count = count + 1;
% Contrast{count}.name = 'iPro';
% Contrast{count}.c = [zeros(2*length(LoadLevels),1)' oX(:,2)'];
% count = count + 1;
% Contrast{count}.name = 'sStm';
% Contrast{count}.c = [oX(:,1)'];
% count = count + 1;
% Contrast{count}.name = 'sRet';
% Contrast{count}.c = [zeros(length(LoadLevels),1)' oX(:,1)'];
% count = count + 1;
% Contrast{count}.name = 'sPro';
% Contrast{count}.c = [zeros(2*length(LoadLevels),1)' oX(:,1)'];

SPM.xCon = {};

NCon = length(Contrast);
for i = 1:NCon
    SPM.xCon(i).STAT = 'T';
    SPM.xCon(i).name = Contrast{i}.name;
    SPM.xCon(i).c = Contrast{i}.c;
end

    