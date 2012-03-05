FontName = 'Courier New';
FontSize = 30;
LineSpacing = 1;
grey=[107,107,107];

mainScreen=0;	     % 0 is the main window

TopLeft = [30 30];
WindowSize = [400 300];
%MainWindowRect = []; % Full screen
MainWindowRect = [TopLeft(1), TopLeft(2), TopLeft(1) + WindowSize(1), TopLeft(2)+WindowSize(2)];
[mainWindow,mainRect]=Screen(mainScreen,'OpenWindow',[grey],[MainWindowRect]);  	% mainWindow is a window pointer to main screen.  mainRect = [0,0,1280,1024]

Screen('TextFont',mainWindow,FontName);
Screen('TextSize',mainWindow,FontSize);

ScreenSize = mainRect(3:4);
Screen('Flip',mainWindow,0);

text = 'Thank you'
[nx, ny, bbox] = DrawFormattedText(mainWindow, text, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow,0);

