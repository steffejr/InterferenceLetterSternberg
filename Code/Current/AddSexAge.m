% Add gender and age to experimental parameter files

function AddSexAge(subid,Sex,Age)
BasePath = 'C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\results\Include';
F = dir(fullfile(BasePath,['iLS_' subid '_*.mat']));

for i = 1:length(F)
    clear ExperimentParameters
    load(F(i).name)
    Changes = 0;
    if ~isfield(ExperimentParameters,'Age')
        ExperimentParameters.Age = Age;
        Changes = 1;
    end
    if ~isfield(ExperimentParameters,'Sex')
        ExperimentParameters.Sex = Sex;
        Changes = 1;
    end
    if Changes 
        Str = ['save ' fullfile(BasePath,F(i).name) ' ExperimentParameters'];
        eval(Str)
    end
end
