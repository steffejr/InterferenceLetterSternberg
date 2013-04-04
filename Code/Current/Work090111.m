
BaseDir = 'C:\Users\jsteffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LetterSternbergWithInterference';
ResultsDir = fullfile(BaseDir,'Results');
DesignDir = fullfile(BaseDir,'SPMDesign');

%P = fullfile(ResultsDir,'iLS_21_050411_1228_Instr0_FB0_NumList4');
P = spm_select(1)
F = strfind(P,'_')
subid = P(F(1)+1:F(2)-1);
date = P(F(2)+1:F(3)-1);
time = P(F(3)+1:F(4)-1);
load(P);

[names durations onsets] = subfnCreateSPMDesignMatrix(ExperimentParameters)
FileName = fullfile(DesignDir,[subid '_DesignSPM' '.mat'])
str = ['save ' FileName ' names durations onsets']
eval(str)
Input = load(FileName)
TR = 2;
hpf = 128;

%job = subfnCreateDesignJob(FileName, TR, hpf);

P = fullfile(DesignDir,'BlankSPMDesignJob');
load(P)

matlabbatch{1}.spm.stats.fmri_design.dir = {DesignDir};
matlabbatch{1}.spm.stats.fmri_design.timing.units = 'secs';
matlabbatch{1}.spm.stats.fmri_design.timing.RT = TR;
 
matlabbatch{1}.spm.stats.fmri_design.sess.nscan = 300;
matlabbatch{1}.spm.stats.fmri_design.sess.multi = {FileName};
spm_jobman('run',matlabbatch) 

load SPM
figure(10)
imagesc(SPM.xX.X)

[m n] = size(SPM.xX.X);
[SPM] = subfnCreateContrats_iLS(SPM)
[eff VRF] = subfnCalcModelEfficiency_iLS(SPM);
NCon = length(SPM.xCon);
%%
figure(11)
clf
for i = 1:NCon
    subplot(NCon+8,2,(i-1)*2+1:i*2)
    C = SPM.xCon(i).c;
    C = [C zeros(1,n-length(C))];
    bar(C)
    axis off
    text(-1,1,SPM.xCon(i).name)
    text(12,1,num2str(VRF(i)))
end
subplot(NCon+8,2,NCon*2+1:NCon*2+16)
imagesc(SPM.xX.X)
axis off







