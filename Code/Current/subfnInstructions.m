function subfnInstructions(WaitTime,ScreenSize,NumberListLength,CharactersBetweenNumbers,CharactersBetweenLetters,mainWindow,Buttons,FontSize)
% Display Instruction "VIDEO"
% For this task you will see a study set of letters. The study set will be
% either 2 DISPLAY or 6 DISPLAY letters
% You will then see an interferring NUMBERS task.
% For this task you will see XX numbers on the LEFT side of the Equals sign
% which you will need to ADD together to determine if their SUM equals the
% number of the RIGHT.
LineSpacing = 1;
InstrLineSpacing = 1.2;
InstructionFontSize = round(0.05*ScreenSize(2));
InstrLowLetters = 'AB';
InstrLowLetters = ['*' CharactersBetweenLetters InstrLowLetters(1) CharactersBetweenLetters ...
    '*\n\n*' CharactersBetweenNumbers  InstrLowLetters(2) CharactersBetweenLetters '*'];
InstrHighLetters = 'ABCDEF';
InstrHighLetters = [InstrHighLetters(1) CharactersBetweenLetters ...
    InstrHighLetters(2) CharactersBetweenLetters ...
    InstrHighLetters(3) '\n\n' ...
    InstrHighLetters(4) CharactersBetweenLetters ...
    InstrHighLetters(5) CharactersBetweenLetters ...
    InstrHighLetters(6)];


InstNumString = char(48+[1:NumberListLength]);
NumString = InstNumString(1);
for mm = 2:NumberListLength
    NumString = sprintf('%s%s%s',NumString,CharactersBetweenNumbers,InstNumString(mm));
end
NumString = [NumString ' = ' num2str(sum(1:NumberListLength))];

Screen('Flip',mainWindow);
InstText1 = ['\nFor this task you will\nsee a study set of letters.'];
InstText2 = ['\nThe study set will\nbe either TWO Letters.'];
InstText3 = ['\nor SIX Letters,\n which you are required\nto remember.'];
InstText4a = ['\nYou will then perform\nan interferring\nADDITION task.'];
InstText4b = ['\nWith a series of\nnumbers on the\nLEFT of an equal sign'];
InstText4c = ['\nand a single number\non the RIGHT.'];
InstText5 = '\nDetermine whether the\nSUM of numbers on the LEFT\n equal the number on the RIGHT';
%InstText6 = ['\nPress ' Buttons.NumberYes{1} ' for YES\nPress  ' Buttons.NumberNo{1} ' for NO.'];
InstText6 = ['\nPress m for YES\nPress z for NO.'];
InstText7 = ['\nYou will then see\n a single PROBE letter.\n'];
InstText8 = ['\nYou are to decide\n whether it was in the\n original study set.'];
    
screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText1 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
[nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText2], 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstrLowLetters , 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText3], 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstrHighLetters , 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
Screen('Flip',mainWindow);
screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText4a , 'center',[], 0,[],[],[],[InstrLineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,[ InstText4b], 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,[InstText4c], 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText5 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
% error if the ESCAPE key is pressed
[ keyIsDown, timeSecs, keyCode ] = KbCheck;
if  ~isempty(strfind( KbName(keyCode),'ESCAPE'))
    sca
    error('ESCAPE Pressed');
end
screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText6 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);


screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText7 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, 'c', 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);

screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText8 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, 'c', 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);

screen('TextSize',mainWindow,InstructionFontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow,InstText6 , 'center',[], 0,[],[],[],[InstrLineSpacing]);
screen('TextSize',mainWindow,FontSize);
[nx, ny, bbox] = DrawFormattedText(mainWindow, 'c', 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
WaitSecs(WaitTime);
WaitSecs(WaitTime);


