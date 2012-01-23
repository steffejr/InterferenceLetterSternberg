function [eff TotalEff X TotalTime] = subfnCalculateDesignEffTempOrder(names,durations,onsets,Trials,hrf)
% Create a design matrix without SPM
% High resolution design will have a sampling period of:
dt = 1/100;
% This sampling period is regardless of the TR
TR = 2;
OffTime = 12;
% find the total scan time but round to the nearest TR
TotalTime = round(((Trials{end}.Auditory.ExpectedOn) + OffTime)/TR)*TR;
Nvols = TotalTime/TR;


Nreg = length(names);

hX = zeros(round(TotalTime/dt),Nreg);
for i = 1:Nreg
    % roiund the onsets to the nearest sample
    tempOn = onsets{i};
    tempDur = durations{i};
    indexOn = round(tempOn/dt);
    indexDur = round(tempDur/dt);
    errOn = tempOn - indexOn*dt;
    errDur = tempDur - indexDur*dt;
    for j = 1:length(tempOn)
        hX(indexOn(j):indexOn(j)+indexDur(j)-1,i)=1;
    end
end
[m n] = size(hX);
% convolve design with hrf
%hrf = spm_hrf(dt);

for i = 1:Nreg
    temp = conv(hX(:,i),hrf);
    hX(:,i) = temp(1:m);
end
% subsample
X = zeros(Nvols, Nreg);
for i = 1:Nreg
    X(:,i) = hX([1:TR/dt:m],i);
    X(:,i) = X(:,i) - mean(X(:,i));
end
X = [X ones(length(X),1)];

% contrasts
c = eye(4);
c = [c zeros(Nreg,1)];
eff = zeros(1,Nreg);
for i = 1:size(c,1)
    eff(i) = 1/(c(i,:)*X'*X*c(i,:)');
end
TotalEff = trace(1./(c*X'*X*c'));

% figure(1)
% imagesc(hX)



