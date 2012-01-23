function TrialStartTime = subfnPresentVisualv2(VisualData, VisualDuration)

FlashRate = 8; % Hertz
FlashTime = 1/FlashRate/2;
TrialStartTime = GetSecs;

% prepare first screen
Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX1);
Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);

for i = 1:VisualData.FlashRate * VisualDuration;
    time = Screen('flip',VisualData.mainWindow);
    % prepare the next screen while the first is on the screen
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
    WaitSecs(FlashTime - (GetSecs - time));
    time=Screen('flip',VisualData.mainWindow);
    Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX1);
    Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
    WaitSecs(FlashTime - (GetSecs - time));
    %             while GetSecs-startTime<time-startTime+frameDuration*3 && GetSecs-startTime<runDuration;
    %                 currentToneLoop=3;playTones
    %             end
end;