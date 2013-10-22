

% --------------------------------------------------------
% Setup misc settings
% --------------------------------------------------------
warning('off','MATLAB:dispatcher:InexactMatch')
% clear all;
% clc
rand('state',sum(100*clock));			% reset random number generator
Screen('Screens');	           			% Make sure all functions (Screen.mex) are in memory.
KbName('UnifyKeyNames');
% --------------------------------------------------------
% What are the button responses
% --------------------------------------------------------
Buttons.NumberNo       = {'1234z'};
Buttons.NumberYes        = {'5678/'};
Buttons.LetterNo       = {'1234z'};
Buttons.LetterYes        = {'5678/'};
% --------------------------------------------------------
FontSize = 60;

% Find the calling directory
s='';
eval('s=which(''RuniLSv2'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
if ~exist(fullfile(ProgramPath,'Results'))
    mkdir(fullfile(ProgramPath,'Results'));
end
OutPath = fullfile(ProgramPath,'Results');

% --------------------------------------------------    
% date
% -------------------------------------------------- 
p.clock=clock;
yy=num2str(p.clock(1));yy=yy(3:4);
mm=num2str(p.clock(2));%mm=mm(3:4);
if length(mm)==1
    mm=['0' mm];
end
dd=num2str(p.clock(3));
if length(dd)==1
    dd=['0' dd];
end
hr=num2str(p.clock(4));
if length(hr)==1
    hr=['0' hr];
end
mn=num2str(p.clock(5));
if length(mn)==1
    mn=['0' mn];
end
date = [mm dd yy '_' hr mn];
% Create output file name
OutFileName = ['TEST_VisMotAud_' date];
OutFilePath  = fullfile(OutPath,OutFileName);


% --------------------------------------------------------
% Setup Font and screen sizes
% --------------------------------------------------------
FontName = 'Courier New';
LineSpacing = 1;
ScreenPos = [30 50];
width = 800;
ScreenSize = [width 0.5*width];

% --------------------------------------------------------
% Check Computer Type
% --------------------------------------------------------
c=computer;
if strcmpi(c,'PCWIN')>0 || strcmpi(c,'PCWIN64')>0
    sysDefault=0;
elseif strcmpi(c,'MAC')>0 || strcmpi(c,'MACI')>0
    sysDefault=1;
else
    disp('System type unknown')
    return
end
KbName('UnifyKeyNames');

% --------------------------------------------------------
% Setup Colors
% --------------------------------------------------------
left=1;
right=2;
black=0;
white=255;
grey=[150,150,150];

% ----------------------------------------------------------------------
% Screen Parameters
% ----------------------------------------------------------------------
rect = []
grey=[107,107,107];
red=[255,20,20];
%red=[75,75,75];
green=[60,160,60];
grey = green;
mainScreen=0;	                                                                                                        % 0 is the main window
[mainWindow,rect]=Screen(mainScreen,'OpenWindow',[grey],[]);  	% mainWindow is a window pointer to main screen.  mainRect = [0,0,1280,1024]
mainRect=[0 0 700 560];

white=WhiteIndex(mainWindow);	                                                                        % white=CLUT index to produce white at current screen depth.
%black=BlackIndex(mainWindow);
black=[0 0 0];
hz=60;%Screen('NominalFrameRate', mainScreen);
frameDuration=1/hz;
framerate	= hz;
viewdist	= 36.0;	                                        % viewing distance in inches
scrn_wd_mm	= 387;	                                        % screen width in mm
scrn_ht_mm	= 292;	                                        % screen height in mm
scrn_wd_in	= scrn_wd_mm / 25.4;	        				% screen height in inches
scrn_ht_in	= scrn_ht_mm / 25.4;	        				% screen height in inches
rtod	        = 180.0 / pi;	                                                                                % radians to degrees conversion factor
scrn_wd_deg	= 2.0 * (rtod * atan(scrn_wd_in/(2.0*viewdist)));	        % screen width in degrees
scrn_ht_deg	= 2.0 * (rtod * atan(scrn_ht_in/(2.0*viewdist)));	        % screen height in degrees
set(0, 'units', 'pixels');	                        % report screen size in pixels, 0=root graphics object
scrnsz = get(0, 'screensize');	                	% get properties of figure
scrn_wd_pix = scrnsz(3);	                        % screen width in pixels
scrn_ht_pix = scrnsz(4);	                        % screen height in pixels
pix_per_deg_h	= scrn_wd_pix / scrn_wd_deg;	                        % conversion factor
pix_per_deg_v	= scrn_ht_pix / scrn_ht_deg;	                        % conversion factor
pix_per_deg	    = mean([pix_per_deg_h pix_per_deg_v]);	        		% conversion factor



% ----------------------------------------------------------------------
% Cue I DONT KNOW WHAT THIS DOES
% ----------------------------------------------------------------------
RectCueSize 	= [sysDefault,sysDefault,140,30];
RectCue 		= CenterRect(RectCueSize,rect);


% Make Erase Text
Screen('FillRect',mainWindow,grey,RectCue);
    
% ----------------------------------------------------------------------
% Misc I DONT KNOW WHAT THIS DOES
% ----------------------------------------------------------------------

% Rush Loops
rushLoopCue={
    'Screen(mainWindow,''WaitBlanking'',1);'
    'Screen(''CopyWindow'',Cue,mainWindow,RectCueSize,RectCue);'
    };

priorityLevel = MaxPriority([mainWindow],['PeekBlanking'],['GetSecs'],['kbCheck']);

% ----------------------------------------------------------------------
% Start Experiment
% ----------------------------------------------------------------------
%ShowCursor
HideCursor;

% % -----------------------------------------------------------------------
% % 			Start Trials
% % -----------------------------------------------------------------------
  Screen('TextFont',mainWindow,FontName);
  Screen('TextSize',mainWindow,FontSize);
    
% Prepare the trigger
%% Config File
if exist('iLS_Config.txt')
    fprintf(1,'Found Config File');
    D=textread('iLS_Config.txt','%s');
    if strmatch(D{1},'[Trigger]')
        Trigger2 = D{2};
    else 
        errordlg('Problem with Config File');
    end
else
    errordlg('Cannot find Config file');
    close
end
ERRfid = fopen('ERRORLOG.txt','w');
Trigger1 = 'r';
if Trigger2 == Trigger1
    Trigger1 = 'd';
end
fprintf(ERRfid,'Loaded Trigger from file\n')

text=['Press "' Trigger1 '"\nthen "' Trigger2 '" to start'];
[nx, ny, bbox] = DrawFormattedText(mainWindow, text, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow,0);
% Trigger 1
[keyIsDown,secs,keycode]=KbCheck;
 while isempty(strfind(KbName(keycode),Trigger1))
     [keyIsDown,secs,keycode]=KbCheck;
 end;
 
% while isempty(find(find(keycode) == double(Trigger1)))
% %while strcmp(KbName(keycode),Trigger2)==0	
%     % wait for button press = 'r'
%     KbName(keycode)
%     [keyIsDown,secs,keycode]=KbCheck;
%     
% end;
text=['Waiting for \n"' Trigger2 '" to start'];
[nx, ny, bbox] = DrawFormattedText(mainWindow, text, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow,0);					% draw fixation dot
% Trigger 2
[keyIsDown,secs,keycode]=KbCheck;
 while isempty(strfind(KbName(keycode),Trigger2))
%while isempty(find(find(keycode) == double(Trigger2)))
%while strcmp(KbName(keycode),Trigger2)==0	
    % wait for button press = 'r'
    [keyIsDown,secs,keycode]=KbCheck;
end;
% Prepare the fixation cross
[FIXnx, FIXny, FIXbbox] = DrawFormattedText(mainWindow, ' ', 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow);
% ----------------------------------------------------------------------
% Audio Setup
% ----------------------------------------------------------------------
rate=Snd('DefaultRate');
rate=8192;
InitializePsychSound
pahandle = PsychPortAudio('Open', [], [], 0, rate, 1);

% Fill the audio playback buffer with the audio data 'wavedata':


% Start audio playback for '1' 1 of the sound data,
% start it immediately (0) and wait for the playback to start, return onset
% timestamp.


freqCorr=698.46;
freqIncorr=440;
beepDuration=.1;

[beepC,a]=MakeBeep(freqCorr,beepDuration,rate);

[beepI,a]=MakeBeep(freqIncorr,beepDuration,rate);

mybeep=[beepC beepI];
mybeep=[beepC beepI];
PsychPortAudio('FillBuffer', pahandle, mybeep);


    
% ----------------------------------------------------------------------
% Checkerboard
% ----------------------------------------------------------------------

[X(:,:,1),MAP] = imread('medcon1.bmp','bmp');
[X(:,:,2),MAP] = imread('medcon2.bmp','bmp');
[m,n]=size(X(:,:,1));
rectCheck=[0 0 m n];
rectCheckCent=CenterRect(rectCheck,mainRect);
textureX1=Screen('MakeTexture', mainWindow, X(:,:,1));
textureX2=Screen('MakeTexture', mainWindow, X(:,:,2));

% ----------------------------------------------------------------------
% Fixation Point
% ----------------------------------------------------------------------
ovalsize=24;
rect=[0 0 ovalsize ovalsize];
rect2=AlignRect(rect,mainRect,'center');
rect=[0 0 ovalsize/2 ovalsize/2];
rect3=AlignRect(rect,mainRect,'center');


startTime=Screen('flip',mainWindow)
FlashRate = 8; % Hertz
FlashTime = 1/FlashRate/2;
VisualDuration = 0.5; % seconds
for j = 1:10
    % numLoops=round(stimDuration(videoCounter)/(8*frameDuration));
    for i = 1:FlashRate * VisualDuration;
        Screen('DrawTexture', mainWindow, textureX1)
        Screen(mainWindow,'FillOval',black,rect2);
        time=Screen('flip',mainWindow);
        WaitSecs(FlashTime)
        
        Screen('DrawTexture', mainWindow, textureX2)
        Screen(mainWindow,'FillOval',black,rect2);
        time=Screen('flip',mainWindow);
        WaitSecs(FlashTime)
        
        %             while GetSecs-startTime<time-startTime+frameDuration*3 && GetSecs-startTime<runDuration;
        %                 currentToneLoop=3;playTones
        %             end
    end;
    WaitSecs(2)
    numAudioLoops=round(2/(.2));
    t1 = PsychPortAudio('Start', pahandle, numAudioLoops, 0, 1);
    WaitSecs(2)
end
numAudioLoops=round(5/(.2));
t1 = PsychPortAudio('Start', pahandle, numAudioLoops, 0, 1);

clc
sca
