% For each trial of this task you will see a flashing checkerboard and hear
% a tone. 
% You need to judge whether the flashing and the tone together are on for a
% short time, less than 1.5 seconds or a long time, more than 1.5 seconds. 
% Once the red cross hair shows on the screen press the button in your left
% hand if you think the trial was short or press the button in your right
% hand if you think the trial was long. 
% please make your decision as fast as possible.
%
% Present some short and long trials and display what they were. Have the
% participant try and give feedback.
function subfnInstructionsTempOrder(mainWindow,VisualData,pahandle,mainRect)
InstrWaitTime = 3;
VisOnTime = 1;
AudOnTime = 1;
InstrLineSpacing = 1.2;

InstText1 = '\nFor this task\nyou will see a checkerboard.';
InstText1b = '\nFocus your attention\non the central black dot';
InstText2 = '\nThe checkerboard\nwill flash.';
InstText3 = '\nAfter which you will hear a tone'
InstText4 = '\nThe the fixation point\nwill change to a red cross.';
InstText5 = '\nWhen it changes, press\nthe button in your right hand';
InstText6 = '\nThat is all.';

[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText1 , 'center',[],  [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)
Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)

Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText1b , 'center',[],  [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)

Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText2 , 'center',[],  [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)

VisTrialStartTime = subfnPresentVisualv2(VisualData, VisOnTime);


[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText3 , 'center',[], [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow,0);
WaitSecs(InstrWaitTime)
subfnPresentAuditory(pahandle,AudOnTime);
WaitSecs(AudOnTime)
Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText4 , 'center',[], [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)

Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
[nx, ny, bbox] = DrawFormattedText(mainWindow, '+', mainRect(3)/2-60*0.36,mainRect(4)/2-60*0.71, [255 0 0],[],[],[],[]);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)

Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
[nx, ny, bbox] = DrawFormattedText(mainWindow, '+', mainRect(3)/2-60*0.36,mainRect(4)/2-60*0.71, [255 0 0],[],[],[],[]);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText5 , 'center',[], [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText6 , 'center',[], [255 255 0],[],[],[],InstrLineSpacing);
Screen('Flip',mainWindow);
WaitSecs(InstrWaitTime)
sca
