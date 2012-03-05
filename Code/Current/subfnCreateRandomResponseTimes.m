function Trials = subfnCreateRandomResponseTimes(Trials)
NTrials = length(Trials);
R = (randg(ones(10*NTrials,1))*0.25);
R = R(find(R>0.2));

for j = 1:NTrials
    Trials{j}.ResponseTime = R(j);
    Trials{j}.Visual.ActualOn = Trials{j}.Visual.ExpectedOn;
    Trials{j}.Auditory.ActualOn = Trials{j}.Auditory.ExpectedOn;
end

