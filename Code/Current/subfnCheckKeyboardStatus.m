function subfnCheckKeyboardStatus(handles)
KbName('UnifyKeyNames')
% turn beep on
DisableKeysForKbCheck([]);
CheckTime = 5; % seconds
WaitChunk = 2;
NCheckTime = CheckTime*WaitChunk;
h = waitbar(0,'Checking Keyboard, please DO NOT touch anything');
[keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
pause(1)
KeyDetectFlag = 0;
for i = 1:NCheckTime
    Start = GetSecs;
    waitbar(i/NCheckTime,h);
    while secs - Start < 1/WaitChunk
        [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
        if keyIsDown
            beep
            fprintf(1,'Detected: %s\n',KbName(find(keyCode)));
            KeyDetectFlag = 1;
        end
    end
end
close(h)
if KeyDetectFlag
    KeyDetectFlag = 0;
   % h2 = warndlg({'A key press was detected!!','','Repeating test and only monitoring the essential keys'})
    h = waitbar(0,{'A KEY PRESS WAS DETECTED','Checking Keyboard again, please DO NOT touch anything'});
    ListOfKeysIgnore = subfnFindNonResponseKeys(handles);
    DisableKeysForKbCheck([ListOfKeysIgnore]);
    pause(1);
    for i = 1:NCheckTime
        Start = GetSecs;
        waitbar(i/NCheckTime,h);
        while secs - Start < 1/WaitChunk
            [keyIsDown, secs, keyCode, deltaSecs] = KbCheck;
            if keyIsDown
                beep
                fprintf(1,'Detected: %s\n',KbName(find(keyCode)));
               KeyDetectFlag = 1;
            end
        end
    end
    close(h)
end

if KeyDetectFlag
   uiwait(warndlg({'One of the response keys is being pressed!','','Please fix and try again.',...
         'The experiment will not work properly if this is not resolved.'}));
end
