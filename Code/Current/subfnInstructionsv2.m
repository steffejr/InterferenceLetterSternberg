function subfnInstructionsv2(WaitTime,ScreenSize,NumberListLength,CharactersBetweenNumbers,CharactersBetweenLetters,mainWindow,Buttons,FontSize,LoadLevels)
% Display Instruction "VIDEO"
% For this task you will see a study set of letters. 
% The instructions are flexible enough to adapt to whatever selections the
% user has made regarding teh number and letter loads.
%
%
LineSpacing = 1;
InstrLineSpacing = 1.2;
InstructionFontSize = round(0.05*ScreenSize(2));
InstrOneLetters = 'A';
InstrOneLetters = ['*' CharactersBetweenLetters '*' CharactersBetweenLetters ...
    '*\n\n*' CharactersBetweenNumbers InstrOneLetters(1) CharactersBetweenLetters '*'];

InstrTwoLetters = 'AB';
InstrTwoLetters = ['*' CharactersBetweenLetters InstrTwoLetters(1) CharactersBetweenLetters ...
    '*\n\n*' CharactersBetweenNumbers  InstrTwoLetters(2) CharactersBetweenLetters '*'];

InstrThreeLetters = 'ABC';
InstrThreeLetters = ['*' CharactersBetweenLetters '*' CharactersBetweenLetters ...
    '*\n\n' InstrThreeLetters(1) CharactersBetweenNumbers  InstrThreeLetters(2) CharactersBetweenLetters InstrThreeLetters(3)];

InstrSixLetters = 'ABCDEF';
InstrSixLetters = [InstrSixLetters(1) CharactersBetweenLetters ...
    InstrSixLetters(2) CharactersBetweenLetters ...
    InstrSixLetters(3) '\n\n' ...
    InstrSixLetters(4) CharactersBetweenLetters ...
    InstrSixLetters(5) CharactersBetweenLetters ...
    InstrSixLetters(6)];

% Number to letter mapping
Num2LetMap = {};
Num2LetMap{1} = 'One';
Num2LetMap{2} = 'Two';
Num2LetMap{3} = 'Three';
Num2LetMap{6} = 'Six';
if NumberListLength
    InstNumString = char(48+[1:NumberListLength]);
    NumString = InstNumString(1);
    for mm = 2:NumberListLength
        NumString = sprintf('%s%s%s',NumString,CharactersBetweenNumbers,InstNumString(mm));
    end
    NumString = [NumString ' = ' num2str(sum(1:NumberListLength))];
end
Screen('Flip',mainWindow);
InstText1 = ['\nFor this task you will\nsee a study set of letters'];

InstText2_1 = ['\nThe study set will\nbe ONE letter'];
InstText2_2 = ['\nThe study set will\nbe TWO letters'];
InstText2_3 = ['\nThe study set will\nbe THREE letters'];
InstText2_6 = ['\nThe study set will\nbe SIX letters'];
InstText2_1b = ['\nor ONE letter'];
InstText2_2b = ['\nor TWO letters'];
InstText2_3b = ['\nor THREE letters'];
InstText2_6b = ['\nor SIX letters'];


%InstText3 = ['\nor SIX Letters,\n which you are required\nto remember.'];
InstText3a = ['\nYou will then perform\nan interferring\nADDITION task'];
InstText3b = ['\nWith a series of\nnumbers on the\nLEFT of an equal sign'];
InstText3c = ['\nand a single number\non the RIGHT'];
InstText3d = '\nDetermine whether the\nSUM of numbers on the LEFT\n equal the number on the RIGHT';
%InstText6 = ['\nPress ' Buttons.NumberYes{1} ' for YES\nPress  ' Buttons.NumberNo{1} ' for NO.'];
InstText3e = ['\nPress / for YES\nPress z for NO.'];
InstText4 = ['\nAfter a delay period'];
InstText5a = ['\nYou will  see\n a single PROBE letter\n'];
InstText5b = ['\nDecide\n whether it was in the\n original study set'];
InstText5c = ['\nPress / for YES\nPress z for NO'];    

Screen('TextSize',mainWindow,InstructionFontSize);

[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText1 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);

% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
str = ['[nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText2_' num2str(LoadLevels(1)) '], ''center'',[], 0,[],[],[],[InstrLineSpacing]);'];
eval(str)
%    [nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText2], 'center',[], 0,[],[],[],[InstrLineSpacing]);
Screen('TextSize',mainWindow,FontSize);
str = ['[nx, ny, bbox] = DrawFormattedText(mainWindow,Instr' Num2LetMap{LoadLevels(1)} 'Letters , ''center'', ''center'', 0,[],[],[],[LineSpacing]);'];
eval(str);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
if length(LoadLevels)>1 & (LoadLevels(1)~=LoadLevels(2))
    for i = 2:length(LoadLevels)
        str = ['[nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText2_' num2str(LoadLevels(i)) 'b], ''center'',[], 0,[],[],[],[InstrLineSpacing]);'];
        eval(str)
        %    [nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText2], 'center',[], 0,[],[],[],[InstrLineSpacing]);
        Screen('TextSize',mainWindow,FontSize);
        str = ['[nx, ny, bbox] = DrawFormattedText(mainWindow,Instr' Num2LetMap{LoadLevels(i)} 'Letters , ''center'', ''center'', 0,[],[],[],[LineSpacing]);'];
        eval(str);
        Screen('Flip',mainWindow);
        WaitSecs(WaitTime);
        % error if the ESCAPE key is pressed
        [ keyIsDown, timeSecs, keyCode ] = KbCheck;
        if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
            sca
            error('ESCAPE Pressed');
        end
    end
end
% Screen('TextSize',mainWindow,InstructionFontSize);
% [nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText3], 'center',[], 0,[],[],[],[InstrLineSpacing]);
% Screen('TextSize',mainWindow,FontSize);
% [nx, ny, bbox] = DrawFormattedText(mainWindow,InstrSixLetters , 'center', 'center', 0,[],[],[],[LineSpacing]);
% Screen('Flip',mainWindow);
% WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
% [ keyIsDown, timeSecs, keyCode ] = KbCheck;
% if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
%     sca
%     error('ESCAPE Pressed');
% end

if NumberListLength>0
    Screen('Flip',mainWindow);
    Screen('TextSize',mainWindow,InstructionFontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,InstText3a , 'center',[], 0,[],[],[],[InstrLineSpacing]);
    Screen('Flip',mainWindow);
    WaitSecs(WaitTime);
    % error if the ESCAPE key is pressed
    [ keyIsDown, timeSecs, keyCode ] = KbCheck;
    if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
        sca
        error('ESCAPE Pressed');
    end
    Screen('TextSize',mainWindow,InstructionFontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,[ InstText3b], 'center',[], 0,[],[],[],[InstrLineSpacing]);
    Screen('TextSize',mainWindow,FontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
    Screen('Flip',mainWindow);
    WaitSecs(WaitTime);
    % error if the ESCAPE key is pressed
    [ keyIsDown, timeSecs, keyCode ] = KbCheck;
    if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
        sca
        error('ESCAPE Pressed');
    end
    Screen('TextSize',mainWindow,InstructionFontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText3c], 'center',[], 0,[],[],[],[InstrLineSpacing]);
    Screen('TextSize',mainWindow,FontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
    Screen('Flip',mainWindow);
    WaitSecs(WaitTime);
    % error if the ESCAPE key is pressed
    [ keyIsDown, timeSecs, keyCode ] = KbCheck;
    if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
        sca
        error('ESCAPE Pressed');
    end
    Screen('TextSize',mainWindow,InstructionFontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,InstText3d , 'center',[], 0,[],[],[],[InstrLineSpacing]);
    Screen('TextSize',mainWindow,FontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
    Screen('Flip',mainWindow);
    WaitSecs(WaitTime);
    % error if the ESCAPE key is pressed
    [ keyIsDown, timeSecs, keyCode ] = KbCheck;
    if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
        sca
        error('ESCAPE Pressed');
    end
    Screen('TextSize',mainWindow,InstructionFontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,InstText3e , 'center',[], 0,[],[],[],[InstrLineSpacing]);
    Screen('TextSize',mainWindow,FontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
    Screen('Flip',mainWindow);
    WaitSecs(WaitTime);
else
    Screen('TextSize',mainWindow,InstructionFontSize);
    [nx, ny, bbox] = DrawFormattedText(mainWindow,InstText4 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
    Screen('Flip',mainWindow);
    WaitSecs(WaitTime+2);
    
end
Screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText5a , 'center',[], 0,[],[],[],[InstrLineSpacing]);
Screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, 'c', 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);

Screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText5b , 'center',[], 0,[],[],[],[InstrLineSpacing]);
Screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, 'c', 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);

Screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText5c , 'center',[], 0,[],[],[],[InstrLineSpacing]);
Screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, 'c', 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
WaitSecs(WaitTime);


