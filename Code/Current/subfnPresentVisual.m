function TrialStartTime = subfnPresentVisual(VisualData, VisualDuration)

FlashRate = 8; % Hertz
FlashTime = 1/FlashRate/2;
TrialStartTime = GetSecs;


for i = 1:VisualData.FlashRate * VisualDuration;
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX1);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);

    time = Screen('flip',VisualData.mainWindow);
    
    
    
    WaitSecs(FlashTime);
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
    %Screen(VisualData.mainWindow,'FillOval',VisualData.black,VisualData.rect2);
    %[nx, ny, bbox] = DrawFormattedText(VisualData.mainWindow, '+', 'center',  'center', [255,0,0]);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
    time=Screen('flip',VisualData.mainWindow);
    WaitSecs(FlashTime);
    
    %             while GetSecs-startTime<time-startTime+frameDuration*3 && GetSecs-startTime<runDuration;
    %                 currentToneLoop=3;playTones
    %             end
end;