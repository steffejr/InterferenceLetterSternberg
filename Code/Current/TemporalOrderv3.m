function [medRT propCor Trials] = TemporalOrderv3(RunType,demog)
%% ToDo
% Add instructions
% Add Thank you screen
% Save results to file
% Add buttons to the main GUI to call this program
% Add the variable durations
% Create GUI for this?
% 3 runs:
% practice/instructions
% run with fixed times
% run with variable durtations
% create optimal ITI
% create SPM regressors

medRT = -99;
propCor = -99;
Trials = -99;
%%
% --------------------------------------------------------
% Setup misc settings
% --------------------------------------------------------
warning('off','MATLAB:dispatcher:InexactMatch')
% clear all;
% clcr5
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
FontName = 'Courier New';
FontSize = 60;
LineSpacing = 1;

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
OutFileName = ['TempOrd_' demog.subid '_' demog.Tag '_' date];
OutFilePath  = fullfile(OutPath,OutFileName);

% ----------------------------------------------------------------------
% Screen Parameters
% ----------------------------------------------------------------------
grey=[107,107,107];
red=[255,20,20];
%red=[75,75,75];
green=[60,160,60];
mainScreen=0;	     % 0 is the main window


TopLeft = [30 30];
WindowSize = [400 300];
MainWindowRect = []; % Full screen
MainWindowRect = [TopLeft(1), TopLeft(2), TopLeft(1) + WindowSize(1), TopLeft(2)+WindowSize(2)];
[mainWindow,mainRect]=Screen(mainScreen,'OpenWindow',[grey],[MainWindowRect]);  	% mainWindow is a window pointer to main screen.  mainRect = [0,0,1280,1024]
ScreenSize = mainRect(3:4);
Screen('Flip',mainWindow,0);


Screen('TextFont',mainWindow,FontName);
Screen('TextSize',mainWindow,FontSize);

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

% ----------------------------------------------------------------------
% Audio
% ----------------------------------------------------------------------

%rate=Snd('DefaultRate');

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
PsychPortAudio('FillBuffer', pahandle, mybeep);
numAudioLoops=round(2/(.2));
% To play the audio:
%t1 = PsychPortAudio('Start', pahandle, numAudioLoops, 0, 1);



% ----------------------------------------------------------------------
% Start Experiment
% ----------------------------------------------------------------------
%HideCursor;

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
% ----------------------------------------------------------------------


% -----------------------------------------------------------------------
%                 Start Trials
% -----------------------------------------------------------------------
% This makes a red cross fixation point


FlashRate = 8; % Hertz
FlashTime = 1/FlashRate/2;

% Create structure of screen information to be passed to the present visual
% program
VisualData = [];
VisualData.mainWindow = mainWindow;
VisualData.textureX1 = textureX1;
VisualData.textureX2 = textureX2;
VisualData.black = black;
VisualData.rect2 = rect2;
VisualData.FlashRate = FlashRate;
VisualData.ScreenSize = ScreenSize;
VisualData.FontSize = FontSize;
VisualData.rect2 = rect2;
% %%

HideCursor;
% Load Design
IntroOff = 12;
EndOff = 10;
switch RunType
    case 'Best'
%         TrialDuration = 3;
        load BestTemporalOrderDesign_013012
        Trials = BestTrials;
        ITI = BestITI;
        NTrials = length(Trials);
%         load('C:\Users\steffener\Desktop\SteffenerColumbia\Grants\K\TaskDesign\LetterSternbergWithInterference/OptimizedTempOrder');
%         NTrials = length(Trials);
    case 'BestVA'
        load BestTemporalOrderDesignVA_021712
        Trials = BestTrials;
        ITI = BestITI;
        NTrials = length(Trials);

    case 'BestAV'
        load BestTemporalOrderDesignVA_021712
        Trials = BestTrials;
        ITI = BestITI;
        NTrials = length(Trials);

    case 'New'
        %% SETUP DESIGN
        % Intro OFF Time in seconds

        % how many blocks of the four trials types are to be presented
        NRepeats = 1;
        % Create the trials in random order
        [Trials Events] = subfnTempOrderDesign(NRepeats,1);
        % How many trials were created, this will be 4*NRepeats
        NTrials = length(Trials);
        % create the ITI time array
        % This is related to the spread in the gamma distribution of ITI
        G = 1.5;
        % This is the maximum time allowed to respond for each trial and the
        % minimum ITI.
        offset = 2; % Seconds
        ITI = subfnTemporalOrderITI(NTrials,G,offset);
        
        ITI = ones(NTrials,1);
        % The maximum time allowed for a response tyo be made. Note that the ITI
        % for each trial (created above) will have this value ADDED to it.
        MaxResponseTime = 2; % Seconds
        % Add the ITI times to the Trial structure along with expected times. Then
        % add the actual times to teh Trials which will alow for a check of actual
        % versus expected for any time delays
        %TrialDuration = 2;
        Trials = subfnAddTemporalOrderTiming(IntroOff, Trials,ITI,MaxResponseTime);
        
end

if strcmp(RunType, 'Instructions')
    subfnInstructionsTempOrderv2(mainWindow,VisualData,pahandle,mainRect)
else
    try
        % Intro off time
        Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
        startTime=Screen('flip',mainWindow)
        WaitSecs(IntroOff);
        % Start the trials
        for j = 1:NTrials
            TrialStartTime = GetSecs;
            % Decide whether this is a VISUAL first or AUDITORY first trial
            if strfind(Trials{j}.name,'V')<strfind(Trials{j}.name,'A')
                % Visual first
                % present visual stimulus
                VisTrialStartTime = subfnPresentVisualv2(VisualData, Trials{j}.Visual.duration);
                % present auditory stimulus
                AudTrialStartTime = subfnPresentAuditory(pahandle,Trials{j}.Auditory.duration);
                % Make sure to wiat for the auditory cue to stop playing before
                % presenting the red cross hair
                WaitSecs(Trials{j}.Auditory.duration);
                %WaitSecs(Trials{j}.Auditory.duration - (GetSecs - AudTrialStartTime));
            else
                % Auditory first
                % present auditory stimulus
                AudTrialStartTime = subfnPresentAuditory(pahandle,Trials{j}.Auditory.duration);
                % Make sure to wiat for the auditory cue to stop playing before
                % presenting the red cross hair
                WaitSecs(Trials{j}.Auditory.duration);
                %WaitSecs(Trials{j}.Auditory.duration - (GetSecs - AudTrialStartTime));
                % present visual stimulus
                VisTrialStartTime = subfnPresentVisualv2(VisualData, Trials{j}.Visual.duration);
            end
            % Prepare the cross hair screen
            Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
            [nx, ny, bbox] = DrawFormattedText(mainWindow, '+', mainRect(3)/2-FontSize*0.36,mainRect(4)/2-FontSize*0.71, [255 0 0],[],[],[],[LineSpacing]);
            time = Screen('flip',mainWindow);
            StartTimeCrosshair = time;
            Trials{j}.Visual.ActualOn = VisTrialStartTime - startTime;
            Trials{j}.Auditory.ActualOn = AudTrialStartTime - startTime;
            
            % Prepare the screen with the fixation CIRCLE for presenting when
            % a response is made
            Screen('DrawTexture', VisualData.mainWindow, VisualData.textureX2);
            Screen(VisualData.mainWindow,'FillOval',[0 0 0],VisualData.rect2);
            % WAIT for a response
            % Use a flag to say that a key was pressed.
            KeyPressFlag = 0;
            % Set NO response to be -99
            Key = '-99';
            RT = -99;
            % Only look for responses during the MaxResponse Time allowed
            % Max Response time is a function of the actual trial. The trial
            % duration is being fixed regardless of what is being presented.
%            MaxResponseTime = TrialDuration - (Trials{j}.Visual.duration + Trials{j}.Auditory.duration);
            MaxResponseTime = 2;
            timeSecs = 0;
            fprintf(1,'EndStim: %0.3f',GetSecs)
            while  time + MaxResponseTime > timeSecs
                [ keyIsDown, timeSecs, keyCode ] = KbCheck;
                if keyIsDown & ~KeyPressFlag
                    % What key was pressed
                    Key = KbName(find(keyCode));
                    if char(Key(1)) ~= Trigger2
                        % if a key is pressed present the black circle fixation
                        % point
                        time = Screen('flip',mainWindow);
                        % calculate this trials response time
                        RT = time - StartTimeCrosshair;
                        % set the flag to stop checking the keys
                        KeyPressFlag = 1;
                    end
                    % Break if the ESCAPE ket is pressed
                    if ~isempty(strmatch(Key,'ESCAPE'))
                        sca
                        error('ESCAPE Pressed');
                    end
                end
            end
            
            % Flip the screen if no button wtttttttttttas pressed
            if KeyPressFlag == 0
                 time = Screen('flip',mainWindow);
            end
            % Store the response to the trial
            Trials{j}.ResponseKey = Key;
            Trials{j}.ResponseTime = RT;
            fprintf(1,', EndRespPeriod: %0.3f\n',GetSecs)
            % Add the response to the Trial
            % wait for the ITI, but note that this is the ITI AFTER the max
            % response time has elapsed
            % Check to see how much time is lost for each trial and make an
            % adjustment to the ITI
            ExpectedDuration = Trials{j}.Visual.duration + Trials{j}.Auditory.duration + MaxResponseTime;
            
           % TimeLeftOver = ExpectedDuration - (Trials{j}.Visual.ActualOn + Trials{j}.Auditory.ActualOn);
            ActualTrialDuration = GetSecs - TrialStartTime;
            
%            TimeDelay = Trials{j}.Visual.ActualOn - Trials{j}.Visual.ExpectedOn;
%            fprintf(1,'Trial %d, Delay: %0.4f seconds\n',j,TimeDelay);
            fprintf(1,'ExpDur: %0.3f, ActDur: %0.3f, ExpOn: %0.3f, ActOn: %0.3f\n',ExpectedDuration,ActualTrialDuration,Trials{j}.Visual.ExpectedOn,Trials{j}.Visual.ActualOn);
            fprintf(1,'Trial ITI: %0.3f,  Actual ITI: %0.3f\n', ITI(j),ITI(j) + ExpectedDuration - ActualTrialDuration);
            WaitSecs(ITI(j) + ExpectedDuration - ActualTrialDuration);

            
            
        end
        WaitSecs(EndOff)
        endTime = GetSecs;
        TotalScanTime = endTime - startTime;
        % Present Thank you screen
        text = 'Thank you'
        [nx, ny, bbox] = DrawFormattedText(mainWindow, text, 'center', 'center', 0,[],[],[],[LineSpacing]);
        Screen('Flip',mainWindow,0);
        WaitSecs(2)
        
        Screen('CloseAll')
        clear mex;
        % Score the results/
        [medRT propCor] = subfnTempOrderResults(Trials);

        %subfnTemporalOrderPlotTiming(Trials)
        % Save data to file
        TempOrderData = {};
        TempOrderData.Trials = Trials;
        TempOrderData.demog = demog;
        TempOrderData.medRT = medRT;
        TempOrderData.propCor = propCor;
        str =  ['save(OutFilePath,''TempOrderData'')'];
        eval(str)
        fprintf(1,'Total Scan Time: %0.2f\n',TotalScanTime);
% ------------
    catch me
        me
        Screen('CloseAll')
        clear mex;
    end
end
