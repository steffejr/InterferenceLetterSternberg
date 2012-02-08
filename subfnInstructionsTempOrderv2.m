function subfnInstructionsTempOrderv2(mainWindow,VisualData,pahandle,mainRect)
Instr = {};
count = 1;
Instr{count} = ['For each trial you will see\na flashing checkerboard\n'...
    'and hear a tone.'];
count = count + 1;
% Instr{count} = ['Decide whether they\nare on for a short\nor long time.'];
% count = count + 1;
Instr{count} = ['Once the red cross hair apears,\n'...
    'decide if this was\na short or long trial.']
count = count + 1;
Instr{count} = ['press the LEFT button \nif you think the trial\nwas SHORT']
count = count + 1;
Instr{count} = ['press the RIGHT button\nif you think the trial\nwas LONG.'];
count = count + 1;
Instr{count} = ['Please make your decision\nas fast as possible.'];
count = count + 1;
Instr{count} = ['Here are some examples.']
count = count + 1;
Instr{count} = ['Now you try.'];
count = count + 1;

Buttons.NumberNo       = {'1234z'};
Buttons.NumberYes        = {'5678/'};

InstrWaitTime = 5;
VisOnTime = 1;
AudOnTime = 1;
InstrLineSpacing = 1.2;


PracticeTrials = {};
PracticeTrials{1}.VisOnTime = 0.5;
PracticeTrials{1}.AudOnTime = 0.5;
PracticeTrials{1}.Tag = 'short';
PracticeTrials{1}.Code = 'VA';
PracticeTrials{1}.CorrectKey = Buttons.NumberNo;
PracticeTrials{2}.VisOnTime = 1;
PracticeTrials{2}.AudOnTime = 1;
PracticeTrials{2}.Tag = 'long';
PracticeTrials{2}.Code = 'VA';
PracticeTrials{2}.CorrectKey = Buttons.NumberYes;  
PracticeTrials{3}.VisOnTime = 0.33;
PracticeTrials{3}.AudOnTime = 0.66;
PracticeTrials{3}.Tag = 'short';
PracticeTrials{3}.Code = 'AV';
PracticeTrials{3}.CorrectKey = Buttons.NumberNo;
PracticeTrials{4}.VisOnTime = 1.2;
PracticeTrials{4}.AudOnTime = 0.8;
PracticeTrials{4}.Tag = 'long';
PracticeTrials{4}.Code = 'AV';
PracticeTrials{4}.CorrectKey = Buttons.NumberYes;  

for i = 1:length(Instr)-1
    [nx, ny, bbox] = DrawFormattedText(mainWindow,Instr{i} , 'center',['center'],  [255 255 0],[],[],[],InstrLineSpacing);
    Screen('Flip',mainWindow);
    WaitSecs(InstrWaitTime)
end


for i = 1:length(PracticeTrials)
    if strcmp(PracticeTrials{i}.Code, 'VA')
        PresentVA(PracticeTrials{i}.VisOnTime,PracticeTrials{i}.AudOnTime, VisualData, pahandle);
    else
        PresentAV(PracticeTrials{i}.VisOnTime,PracticeTrials{i}.AudOnTime, VisualData, pahandle);
    end
    PresentCrossHair(VisualData,mainWindow,mainRect)
    WaitSecs(1)
    PresentTrialTag(PracticeTrials{i}.Tag,mainWindow,VisualData,InstrLineSpacing,InstrWaitTime)
end
[nx, ny, bbox] = DrawFormattedText(mainWindow,Instr{end} , 'center',['center'],  [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)
for i = 1:length(PracticeTrials)
    if strcmp(PracticeTrials{i}.Code, 'VA')
        PresentVA(PracticeTrials{i}.VisOnTime,PracticeTrials{i}.AudOnTime, VisualData, pahandle);
    else
        PresentAV(PracticeTrials{i}.VisOnTime,PracticeTrials{i}.AudOnTime, VisualData, pahandle);
    end
    PresentCrossHair(VisualData,mainWindow,mainRect)
    [Key RT] = WaitForFeedback(mainWindow,VisualData)
    PresentFeedback(Key,mainWindow,VisualData,InstrLineSpacing,InstrWaitTime,PracticeTrials{i}.CorrectKey)
end
sca


function [Key RT] = WaitForFeedback(mainWindow,VisualData)
    timeSecs = 0;
    
    KeyPressFlag = 0;
    % Set NO response to be -99
    Key = '-99';
    RT = -99;
    % Only look for responses during the MaxResponse Time allowed
    % Max Response time is a function of the actual trial. The trial
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
    MaxResponseTime = 2;
    time = GetSecs;
    StartTimeCrosshair = time;
    while  time + MaxResponseTime > timeSecs
        [ keyIsDown, timeSecs, keyCode ] = KbCheck;
        if keyIsDown & ~KeyPressFlag
            % if a key is pressed present the black circle fixation
            % point
            time = Screen('flip',mainWindow);
            % calculate this trials response time
            RT = time - StartTimeCrosshair;
            % What key was pressed
            Key = KbName(find(keyCode));
            % set the flag to stop checking the keys
            KeyPressFlag = 1;
            % Break if the ESCAPE ket is pressed
            if ~isempty(strmatch(Key,'ESCAPE'))
                sca
                error('ESCAPE Pressed');
            end
        end
    end



function PresentFeedback(Key,mainWindow,VisualData,InstrLineSpacing,InstrWaitTime,CorrectKey)

    if ~isempty(strfind(char(CorrectKey),Key(1)))
        Response = 'Correct'
    else
        Response = 'Incorrect'
    end
    Text = [Response]
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,Text , 'center',[], [255 255 0],[],[],[],InstrLineSpacing);
    Screen('Flip',mainWindow);
    WaitSecs(InstrWaitTime)


function PresentCrossHair(VisualData,mainWindow,mainRect)
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
    [nx, ny, bbox] = DrawFormattedText(mainWindow, '+', mainRect(3)/2-60*0.36,mainRect(4)/2-60*0.71, [255 0 0],[],[],[],[]);
    Screen('Flip',mainWindow);

function PresentTrialTag(Tag,mainWindow,VisualData,InstrLineSpacing,InstrWaitTime)
    Text = ['That was a ' Tag ' trial.']
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,Text , 'center',[], [255 255 0],[],[],[],InstrLineSpacing);
    Screen('Flip',mainWindow);
    WaitSecs(InstrWaitTime)
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
    Screen('Flip',mainWindow);

function PresentVA(VisOnTime,AudOnTime, VisualData, pahandle)
% Visual first
% present visual stimulus
VisTrialStartTime = subfnPresentVisualv2(VisualData, VisOnTime);
% present auditory stimulus
AudTrialStartTime = subfnPresentAuditory(pahandle,AudOnTime);
% Make sure to wiat for the auditory cue to stop playing before
% presenting the red cross hair
WaitSecs(AudOnTime - (GetSecs - AudTrialStartTime));

function PresentAV(VisOnTime,AudOnTime, VisualData, pahandle)
% Auditory first
% present auditory stimulus
AudTrialStartTime = subfnPresentAuditory(pahandle,AudOnTime);
% Make sure to wiat for the auditory cue to stop playing before
% presenting the red cross hair
WaitSecs(AudOnTime - (GetSecs - AudTrialStartTime));
% present visual stimulus
VisTrialStartTime = subfnPresentVisualv2(VisualData, VisOnTime);
