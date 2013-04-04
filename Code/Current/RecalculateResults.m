BasePath = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\Results\Include';
cd(BasePath)
%BasePath = 'C:\Users\Makaye\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LEtterSternbergWithInterference\Results';
F = dir(fullfile(BasePath,'*.mat'));
for i = 1:length(F)
    clear ExperimentParameters
    load(F(i).name)
    [Trials Results] = subfnCorrectResponses_LetNum(ExperimentParameters);
    ExperimentParameters.Trials = Trials;
    ExperimentParameters.Results = Results;
    Str = ['save ' F(i).name ' ExperimentParameters'];
    eval(Str);
end

    
