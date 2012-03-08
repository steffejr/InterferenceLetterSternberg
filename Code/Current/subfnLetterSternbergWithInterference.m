function [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog,  PresentInstructionsFlag,FeedbackFlag,NumberListLength,NRepeats,LoadLevels,handles)
%% Task description for Letter Sternberg
% The LS task will have two load levels of 2 and 6 letters along with a
% retention period and a probe phase. The retention phase will have
% interference in it. The interference will be the presentation of an
% addtion task where subjects see either 
%
%% TO DO LIST
% 10/14/11
% DONE --Trying to make sure that no consecutive trials have the same letters in
%   their study sets and that the same probe letter is not consecutive. This
%   can run out of possible letters. So I can change he way I create the
%   letters lists so that it is inclusive , this is 5005 for 6 letters but
%   only 105 for 2 letters. I can also have it trial to make a design and if
%   it fails just try again. This may be the best approach because it doesnt
%   seem to fail all the time. This is all done in the subfnCreateDesign.

% * TODO-- Add an ITI for the interference version
% * TODO -- Add a pull-down for selecting the type of ITI distribution you would like.  
% * DONE --Work on the ITI distributions so they are the same as for the PsyScope
% LS version.
% * DONE -- finish creating and testing the design matrices for SPM.
%   The design matrices are not very efficient for the probe conditions.
%   This seems to be the result of the RT modeling of this pahse of the
%   experiment. I have not been able to come with any improvement.
%
% * DONE--Edit Create Design so that it outputs the correct number of trials 
%   based on the letter load and the number load instead of blocks of 16.
% * DONE--Add the ability to enter sex, age and date of birth on the GUI. These
% values need to be transfered to the saved data file also.
% * DONE--Add the ability to present 3 letters as a load level. Make it so the
% user can select the 1/3/6 load level condition from the pull down menus
% on the GUI.


% * There is a drift in time, which I believe is due to the feedback check
% * The subfnCorrectResponses needs to be updated based on all the
%       changes in the current program, (see Feedback section). 
% * Check whether the ITI optimizes the detection ability of the GLM fMRI
%       design matrix
% * DONE: Need to add a structure containing experimental details, did they see
%       instructions? feedback? timing?
% * DONE: FOund and fixed a bug where the program would interpret a DOUBLE
%       key press as ESCAPE and exit the program.
% * DONE: Typo in instructions
% * DONE: write performance to screen
% * add easy functionality for feedback trials and non-feedback runs
% * add a pause between runs, so there is a sense of accomplishment
% * DONE: Add an ESCAPE capability, if the ESC key is pressed during the
%       experiment it will be caught and the program will terminate.
%       - The program will check for the escape key whenever it expects a
%       response furing the main task. During the instruction phase it
%       only checks before the screen text changes. Therefore, you will
%       need to press and hold the escape key until the program stops.
% * DONE: NEED TO DECIDE ON BEST SPACING. 
%       Add horizontal space between the letters and numbers when displayed
% * DONE: Add trigger in beginning
% * DONE: Figure out why windows 10 and 11 are opened
% * DONE: Add feedback to the experimenter
% * DONE: Record button responses and reaction time
%       - The button presses are recorded, BUT the last button pressed is
%       what gets saved and not the first. What is needed is to save the
%       button presses as ARRAYS thereby allowing multiple button presses
%       to be recorded.
% * DONE: Add option to NOT show numbers
%       - This may be possible by putting a check in the beginning. And
%       then the text for all the numbers can be replaced by spaces. This
%       will be done in the beginning during the ITI period.
% * DONE: Add option for feedback
%       - This will be done with a separate version of the program. This is
%       becuase I do not want the program to be making decisions with
%       if/then checks during stimulus presentation time when accurate
%       timing is important.
%       -- This code is written at the end of this file. It will need to be
%       incorporated into a different version of this with changes to the
%       ITI and wait times.
% * DONE: Write out results to file
%       - I would like to write the data out to a MatLab structure that 
%       would make it easy to create design matrices out of. To do this I will
%       append timing and response data to the existing Trials Structure. It
%       would be nice to know which trials corresponded to each of the
%       different conditions. I could have the "subfnCreateDesign" program
%       return the Design matrix which has these codes in it.
%
% * Check with Brian about the criteria for choosing the letters.
% * DONE: How many practice blocks? 6 with feedback, 1 without
% * How many with feedback, how many without?
% * DONE: This is not applicable because all letters are visually presented at the same time. 
%      Minimize the number of times that the probe is the last item in the
%      list. See Altamura et al. 2007. 
% * DONE: I am using a list that Brian provided which excludes X. And I am
%       using a SERIF font (Courier New) which allows easy distinction of a
%       lowercase L.
%   Remove the letter X? from the letter list, see Sakai et al. 2002. What
%   about lowercase(L)?
% * DONE: Add fixation cross -- therefore, need to switch between two windows
%   each of which has text on it.
% * DONE: Also make sure that the total task duration is of a fixed duration.
%   This is an issue because of the random ITI. Any variance in the task
%   duration will be absorbed with the end delay period. 
% * DONE: Add a "Thank you / finished screen at the end.
%
% * Known issues
%       -- there seems to be a slight drift in the timing. This is the
%       result of the checking for responses for the probe letter. The
%       drift is not corrected for with the following ITI. The same drift
%       shows up after the Retention period task, but the post retetion
%       pause corrects for it.
% * Potential issues that may appear
%       -- on laptops the collecting responses may not work because of
%       apparent stuck buttons. I do not have an answer for this.
%
% Written by Jason Steffener
% January 2011
%%
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
Buttons.NumberNo       = handles.Buttons_NumberNo;
Buttons.NumberYes        = handles.Buttons_NumberYes;
Buttons.LetterNo       = handles.Buttons_LetterNo;
Buttons.LetterYes        = handles.Buttons_LetterYes;
% --------------------------------------------------------
% What are the triggers
% --------------------------------------------------------
Trigger1 = handles.Trigger1;
Trigger2 = handles.Trigger2;
TriggerText1 = handles.TriggerText1;
TriggerText2  = handles.TriggerText2;
% --------------------------------------------------------
% Should the probe letter be removed after a button press:
% YES for iLS
% NO for Montpellier
if strcmp(handles.Location,'Montpellier')
%if strcmp(get(handles.Montpellier,'Checked'),'on')
    MontpellierFlag = 1;
else
    MontpellierFlag = 0;
end
% --------------------------------------------------------
% Prepare output file name
% --------------------------------------------------------
% Find the calling directory
s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);
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
OutFileName = ['iLS_' demog.subid '_' demog.Tag '_' date '_Instr' num2str(PresentInstructionsFlag) '_FB'...
    num2str(FeedbackFlag) '_NumList' num2str(NumberListLength)];
OutFilePath  = fullfile(OutPath,OutFileName);

% --------------------------------------------------------
% Setup Experiment
% --------------------------------------------------------
[Trials Design] = subfnCreateDesign(NRepeats,NumberListLength, LoadLevels);
NTrials = length(Trials);

% --------------------------------------------------------
% Setup Font and screen sizes
% --------------------------------------------------------
%FontName1 = 'Courier New';
FontName1 = handles.Font1;
FontName2 = handles.Font2;
FontSize = handles.FontSize;

LineSpacing = 1;
ScreenPos = [30 50];
width = 800;s
ScreenSize = [width 0.025*width];

 
% Create handles.FontSize based on a proportion of the Window size

% --------------------------------------------------------
% Timings
% --------------------------------------------------------
% Note that the ITI is actually presented BEFORE the trial starts. This
% just made it easier in the code.
% So the experiment goes:
%   Start(t=0)/IntroDelay/ITI(1)/Trial(1)/ITI(2)/Trial(2)...Trial(end)/EndDelay
% The experiment uses the WAITUNTIL funtionaility for all timing. This
% corrects for any delays that may occur in preparing and switching
% stimuli. Therefore, stimuli for the next task phase are prepared in the
% previous task phase. This creates timing precision on the order of
% 10^(-7) seconds.
% 
% The timings will adjust based on teh study selected

IntroDelay =        handles.IntroDelay;
EncodeTime =        handles.EncodeTime;
PreRetTime =        handles.PreRetTime;
RetentionTime =     handles.RetentionTime;
PostRetTime =       handles.PostRetTime;
ProbeTime =         handles.ProbeTime;
FinalDelay =          handles.FinalDelay;
% Wait time for instructions
WaitTime = handles.WaitTime;
% Create the ITIs
ITI = subfnCreateITI(NTrials);
ExpectedMeanITI = mean(ITI);

%%% Using a gamma distributed set of ITIs that have a sum for 32 trials
%%% to be 81 seconds.
%ITI = (randg(ones(NTrials,1))*2);
% See if an optimal set of ITIs is included for this run
OptimalITIName = ['iLS_' handles.Location '_' handles.Function '_ITI.mat']
OptimalITIs = fullfile(ProgramPath,'OptimalDesigns',OptimalITIName);
if exist(OptimalITIs)
    clear ITI
    load(OptimalITIs)
else
    ITI = (round(((randg(ones(NTrials,1))*2) + 1)*100)/100);
end
% Set ITI{1} equal to zero
ITI(1) = 0;
ExpectedMeanITI = mean(ITI);


% --------------------------------------------------------
% Populate the Trials structure to be ready for the timing information.
% This will decrease the memory demands later when this structure is being
% written to.
for i = 1:NTrials
    Trials{i}.EncodeStartTime = -99;
    Trials{i}.PreRetStartTime = -99;
    Trials{i}.RetentionStartTime = -99;
    Trials{i}.PostRetStartTime = -99;
    Trials{i}.ProbeStartTime = -99;
    Trials{i}.ITIStartTime = -99;
    Trials{i}.ITIDuration = -99;
    Trials{i}.LetterResponseTime = ones(1,10)*(-99);
    Trials{i}.LetterResponseButton = cell(1,10);
    % whether this the YES coded button was pressed, the NO button or
    % something unknown
    Trials{i}.LetterResponseCode = ''; 
    % whether the respsponse was a hit(HT), a miss(MS), a false alarm(FA)
    % or a correct rejection(CR)
    Trials{i}.LetterResponseAcc = ''; 
    Trials{i}.NumberResponseTime = ones(1,10)*(-99);
    Trials{i}.NumberResponseButton = cell(1,10);
    Trials{i}.NumberResponseCode = -99;
    Trials{i}.NumberResponseAcc = ''; 
end

ExpectedWithinTrialElaspsedTimes = [];
ExpectedWithinTrialElaspsedTimes(1,1) = 0;
ExpectedWithinTrialElaspsedTimes(2,1) = ExpectedWithinTrialElaspsedTimes(1) + EncodeTime;
ExpectedWithinTrialElaspsedTimes(3,1) = ExpectedWithinTrialElaspsedTimes(2) + PreRetTime;
ExpectedWithinTrialElaspsedTimes(4,1) = ExpectedWithinTrialElaspsedTimes(3) + RetentionTime;
ExpectedWithinTrialElaspsedTimes(5,1) = ExpectedWithinTrialElaspsedTimes(4) + PostRetTime;
ExpectedWithinTrialElaspsedTimes(6,1) = ExpectedWithinTrialElaspsedTimes(5) + ProbeTime;
TotalTrialTime = ExpectedWithinTrialElaspsedTimes(6,1);

% --------------------------------------------------------
% Set End delay
% --------------------------------------------------------
% The end period will be set based on the expected ITI values and the number of
% trials.
ActualDuration = NTrials*TotalTrialTime + sum(ITI(1:NTrials));
ExpectedDuration = NTrials*(TotalTrialTime + ExpectedMeanITI) + FinalDelay;
% Check to make sure that the ITI parameters were not changed without
% changing the expectedMeanITI
if ExpectedDuration < ActualDuration
    error('The ITI distributions need to be fixed!');
end
EndDelay = ExpectedDuration - ActualDuration;
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
color = grey;
mainScreen = 0;

CharactersBetweenNumbers = '  '; % for the number list display, either spaces or PLUS signs
CharactersBetweenLetters = '  '; % for the number list display, either spaces or PLUS signs

%rect = [ScreenPos ScreenSize]; % USE THIS FOR JUST A WINDOW
rect = []; %    USE THSI FOR THE FULL SCREEN
screenNumber = max(Screen('Screens'));

TopLeft = [30 30];
WindowSize = [400 300];
MainWindowRect = []; % Full screen
%MainWindowRect = [TopLeft(1), TopLeft(2), TopLeft(1) + WindowSize(1), TopLeft(2)+WindowSize(2)];
[mainWindow,rect]=Screen(mainScreen,'OpenWindow',[grey],[MainWindowRect]);  	% mainWindow is a window pointer to main screen.  mainRect = [0,0,1280,1024]

%[mainWindow,rect] = Screen(mainScreen,'OpenWindow',grey,rect);
ScreenSize = rect(3:4);

%round(0.1*ScreenSize(2));

RectTextSize = [sysDefault,sysDefault,400,300];
RectText 		= CenterRect(RectTextSize,rect);


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
%HideCursor;

% % -----------------------------------------------------------------------
% % 			Start Trials
% % -----------------------------------------------------------------------
  Screen('TextFont',mainWindow,FontName1);
  Screen('TextSize',mainWindow,FontSize);
    
%
% --------------------------------------------------------
% Present Instructions
% --------------------------------------------------------
if PresentInstructionsFlag
    if MontpellierFlag
        subfnInstructionsFrench(WaitTime,ScreenSize,NumberListLength,CharactersBetweenNumbers,CharactersBetweenLetters,mainWindow,handles,LoadLevels);
    else
        subfnInstructionsEnglish(WaitTime,ScreenSize,NumberListLength,CharactersBetweenNumbers,CharactersBetweenLetters,mainWindow,handles,LoadLevels);
    end
end
% --------------------------------------------------------
% EncodeStart/PreRetStart/RetStart/PostRetStart/ProbeStart/
TrialTimes = zeros(5 + 1,6);
% --------------------------------------------------------
% Prepare the trigger
if Trigger2 == Trigger1
    Trigger1 = 'd';
end

%text=['Press "' Trigger1 '"\nthen "' Trigger2 '" to start'];

[nx, ny, bbox] = DrawFormattedText(mainWindow, TriggerText1, 'center', 'center', 0,[],[],[],[LineSpacing]);
Screen('Flip',mainWindow,0);
% Trigger 1
[keyIsDown,secs,keycode]=KbCheck;
 while isempty(strfind(KbName(keycode),Trigger1))
     [keyIsDown,secs,keycode]=KbCheck;
 end;

% text=['Waiting for \n"' Trigger2 '" to start'];
[nx, ny, bbox] = DrawFormattedText(mainWindow, TriggerText2, 'center', 'center', 0,[],[],[],[LineSpacing]);
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
TrialTimes(1,1) = GetSecs;
% Wait for the intro delay to elapse
TrialTimes(2,:) = WaitSecs('UntilTime',TrialTimes(1,1) + IntroDelay);
%%
for trialIndex = 1:NTrials 
    % The experiment is created using the sufnCreateDesign. This function
    % outputs a structure of Trials. This part of the script cycles over
    % these trials and presents them.
    % 
    % The Encoding Letter Strings should be prepared duting the Inter-trial
    % interval. In order to do this the Initial delay period needs to be
    % appended to the begining of the ITI list.
    % First prepare letters
    % Then wait 
    % Then present letters
    
    % PREPARE THE ENCODING SET OF LETTERS
    % Low Letter List
     if length(Trials{trialIndex}.LetList) == 1
         LetEncodeString = ['*' CharactersBetweenLetters Trials{trialIndex}.LetList(1) CharactersBetweenLetters ...
             '*\n\n*' CharactersBetweenLetters '*' CharactersBetweenLetters '*'];
    end
    if length(Trials{trialIndex}.LetList) == 2
         LetEncodeString = ['*' CharactersBetweenLetters Trials{trialIndex}.LetList(1) CharactersBetweenLetters ...
             '*\n\n*' CharactersBetweenLetters Trials{trialIndex}.LetList(2) CharactersBetweenLetters '*'];
    end
     if length(Trials{trialIndex}.LetList) == 3
        LetEncodeString = [Trials{trialIndex}.LetList(1) CharactersBetweenLetters Trials{trialIndex}.LetList(2) ...
            CharactersBetweenLetters Trials{trialIndex}.LetList(3) '\n\n' ...
            '*' CharactersBetweenLetters '*' CharactersBetweenLetters '*'];
    end
    % High Letter List 
    if length(Trials{trialIndex}.LetList) == 6
        LetEncodeString = [Trials{trialIndex}.LetList(1) CharactersBetweenLetters Trials{trialIndex}.LetList(2) ...
            CharactersBetweenLetters Trials{trialIndex}.LetList(3) '\n\n' ...
            Trials{trialIndex}.LetList(4) CharactersBetweenLetters Trials{trialIndex}.LetList(5) ...
            CharactersBetweenLetters Trials{trialIndex}.LetList(6)];
    end
    LetProbeString = Trials{trialIndex}.LetProbe;
    %NumString = [Trials{trialIndex}.NumList ' = ' Trials{trialIndex}.NumProbe];
    if NumberListLength == 0
        NoNumbersFlag = 1;
    else
        NoNumbersFlag = 0;
    end
    %warndlg([num2str(NoNumbersFlag)]);
    if NoNumbersFlag == 1
        NumString = ' ';
    else
        % Add characters between the numbers. I am saying characters
        % because these can be PLUS signs or spaces.
        NumString = Trials{trialIndex}.NumList(1);
        for mm = 2:NumberListLength
            NumString = sprintf('%s%s%s',NumString,CharactersBetweenNumbers,Trials{trialIndex}.NumList(mm));
        end
        NumString = [NumString ' = ' Trials{trialIndex}.NumProbe];
    end
    % ------------------------------------------------
    % Encoding ---------------------------------------
    % Prepare the Display of the Encoding text
    [nx, ny, bbox] = DrawFormattedText(mainWindow, LetEncodeString, 'center', 'center', 0,[],[],[],[LineSpacing]);
    % After all preparation is done let the ITI finish then get the trial
    % start time, then present the stimulus.
    % ITI Wait Period
    % ------------------------------------------------
    % WAIT 1
    TrialTimes(trialIndex + 2,1) = WaitSecs('UntilTime',TrialTimes(trialIndex + 1,end) + ITI(trialIndex));
    % Present Encode Letters
    Screen('Flip',mainWindow);
  
    % Prepare the fixation cross
     [FIXnx, FIXny, FIXbbox] = DrawFormattedText(mainWindow, ' ', 'center', 'center', 0,[],[],[],[LineSpacing]);
    % Wait for the Encoding period
    % ------------------------------------------------
    % WAIT 2
     TrialTimes(trialIndex + 2,2) = WaitSecs('UntilTime',TrialTimes(trialIndex + 2,1) + ExpectedWithinTrialElaspsedTimes(2));
     % Display the fixation cross
    Screen('Flip',mainWindow);
   
    % ------------------------------------------------
    % Prepare the Display of the Retention period test
    [nx, ny, bbox] = DrawFormattedText(mainWindow, NumString, 'center', 'center', 0);
    % Wait for the Pre-retention delay
    % ------------------------------------------------
    % WAIT 3
    TrialTimes(trialIndex + 2,3) = WaitSecs('UntilTime',TrialTimes(trialIndex + 2,1) + ExpectedWithinTrialElaspsedTimes(3));
    % ------------------------------------------------

    % Display the retention test
    Screen('Flip',mainWindow);
    % Prepare the fixation cross
     [FIXnx, FIXny, FIXbbox] = DrawFormattedText(mainWindow, ' ', 'center', 'center', 0,[],[],[],[LineSpacing]);
     % Check for user response
    % Use a WHILE loop that will continually check for keyboard presses
    % once every 5 millisends, this is built into the KbCCheck function
    % If a button is pressed it is printed to the screen. The WHILE loop
    % will be come false if the time when KbCheck executes exceeds the
    % ProbeTime. 
    timeSecs = 0;
    PressCount = 1;
    while (TrialTimes(trialIndex + 2,3) + RetentionTime) > timeSecs
        [ keyIsDown, timeSecs, keyCode ] = KbCheck;
        if keyIsDown
             Key = KbName(find(keyCode));
             if char(Key(1)) ~= Trigger2
                Trials{trialIndex}.NumberResponseTime(PressCount) = timeSecs - TrialTimes(trialIndex + 2,3);
                Trials{trialIndex}.NumberResponseButton{PressCount} = KbName(keyCode);
                % Break if the ESCAPE ket is pressed
                F = find(keyCode);
                for mm = 1:length(F)
                    if ~isempty(strmatch(KbName(F(mm)),'ESCAPE'))
                        sca
                        error('ESCAPE Pressed');
                    end
                end
             end
            % If the user holds down a key, KbCheck will report multiple events.
            % To condense multiple 'keyDown' events into a single event, we wait until all
            % keys have been released.            
            while KbCheck; end
            PressCount = PressCount + 1;
        end
    end
    TrialTimes(trialIndex + 2,4) = GetSecs;
     % Wait for Retention Period
    % ------------------------------------------------
    % WAIT 4
%     TrialTimes(trialIndex + 2,4) = WaitSecs('UntilTime',TrialTimes(trialIndex + 2,1) + ExpectedWithinTrialElaspsedTimes(4));
    % Display the post-retention fixation cross
    Screen('Flip',mainWindow);
    % Prepare Probe text during the Post-Retention display
    % Change the FONT
    Screen('TextFont',mainWindow,FontName2);
    % The font Cursif is much larger in the up-down direction and needs to
    % be adjusted.
    if strcmp(FontName2, 'Cursif')
        [nx, ny, bbox] = DrawFormattedText(mainWindow, LetProbeString, 'center',ScreenSize(2)/2-FontSize/2, 0);
    else
        [nx, ny, bbox] = DrawFormattedText(mainWindow, LetProbeString, 'center','center', 0);
    end
    % Change the FONT Back
    Screen('TextFont',mainWindow,FontName1);
    % Wait for the post-retention delay time
    % ------------------------------------------------
    % WAIT 5
    TrialTimes(trialIndex + 2,5) = WaitSecs('UntilTime',TrialTimes(trialIndex + 2,1) + ExpectedWithinTrialElaspsedTimes(5));
    % ---------------------------------------
    % Display Probe
    Screen('Flip',mainWindow);
    % ASSUME that it takes longer to make a response than it does it
    % prepare the fixation cross; therefore, prepare it before starting to
    % check for responses. 
    [FIXnx, FIXny, FIXbbox] = DrawFormattedText(mainWindow, ' ', 'center', 'center', 0,[],[],[],[LineSpacing]);
    % Check for user response
    % Use a WHILE loop that will continually check for keyboard presses
    % once every 5 millisends, this is built into the KbCCheck function
    % If a button is pressed it is printed to the screen. The WHILE loop
    % will be come false if the time when KbCheck executes exceeds the
    % ProbeTime. 
    timeSecs = 0;
    PressCount = 1;
    while (TrialTimes(trialIndex + 2,5) + ProbeTime) > timeSecs
        [ keyIsDown, timeSecs, keyCode ] = KbCheck;
        if keyIsDown
            Key = KbName(find(keyCode));
             if char(Key(1)) ~= Trigger2
                 Trials{trialIndex}.LetterResponseTime(PressCount) = timeSecs - TrialTimes(trialIndex + 2,5);
                 Trials{trialIndex}.LetterResponseButton{PressCount} = KbName(keyCode);
                 % Break if the ESCAPE ket is pressed
                 F = find(keyCode);
                 for mm = 1:length(F)
                     if ~isempty(strmatch(KbName(F(mm)),'ESCAPE'))
                         sca
                         error('ESCAPE Pressed');
                     end
                 end
                 % If the user holds down a key, KbCheck will report multiple events.
                 % To condense multiple 'keyDown' events into a single event, we wait until all
                 % keys have been released. 
                 while KbCheck; end
                 PressCount = PressCount + 1;
                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                 % If a key is pressed take away the probe letter
                 if ~MontpellierFlag
                     Screen('Flip',mainWindow);
                 end
                 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
             end
        end
        
        
    end
    TrialTimes(trialIndex + 2,6) = GetSecs;
    % Display the fixation cross
    Screen('Flip',mainWindow);
    % Display Feedback
    if FeedbackFlag
        if ~NoNumbersFlag
            temp = max(find((Trials{trialIndex}.NumberResponseTime>-99)));
            % When a button is pressed the UPPER and LOWER versions of that ket
            % press are recorded. Therefore, a key board 1 is recorded as 1!.
            % Therefore, the first value is taken.
            NumberResponse = char(Trials{trialIndex}.NumberResponseButton{temp});
            if length(NumberResponse)
                NumberResponse = NumberResponse(1);
            end
            if temp
                if (~isempty(strfind(Trials{trialIndex}.NumType,'POS')) & ~isempty(strfind(char(Buttons.NumberNo),NumberResponse))) || ...
                        (~isempty(strfind(Trials{trialIndex}.NumType,'NEG')) & ~isempty(strfind(char(Buttons.NumberYes),NumberResponse)))
                    DisplayTrialAnswer = handles.NumbersIncorrect;
                    [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3-FontSize, [255, 0, 0]);
                elseif (~isempty(strfind(Trials{trialIndex}.NumType,'POS')) & ~isempty(strfind(char(Buttons.NumberYes),NumberResponse))) || ...
                        (~isempty(strfind(Trials{trialIndex}.NumType,'NEG')) & ~isempty(strfind(char(Buttons.NumberNo),NumberResponse)))
                    DisplayTrialAnswer = handles.NumbersCorrect;
                    [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3-FontSize, [0, 255, 0]);
                else
                    DisplayTrialAnswer = 'Numbers: ??';
                    [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3-FontSize, [0, 0, 0]);
                end
            else
                DisplayTrialAnswer = handles.NumbersTimeout;
                [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3-FontSize, [0, 0, 0]);
            end
        end
        temp = max(find(Trials{trialIndex}.LetterResponseTime>-99));
        LetterResponse = char(Trials{trialIndex}.LetterResponseButton{temp});
        if length(LetterResponse)
            LetterResponse = LetterResponse(1);
        end
        if temp
            if (~isempty(strfind(Trials{trialIndex}.LetType,'POS')) & ~isempty(strfind(char(Buttons.LetterNo),LetterResponse))) || ...
                    (~isempty(strfind(Trials{trialIndex}.LetType,'NEG')) & ~isempty(strfind(char(Buttons.LetterYes),LetterResponse)))
                DisplayTrialAnswer = handles.LettersIncorrect;
                [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3+FontSize, [255, 0, 0]);
            elseif (~isempty(strfind(Trials{trialIndex}.LetType,'POS')) & ~isempty(strfind(char(Buttons.LetterYes),LetterResponse))) || ...
                    (~isempty(strfind(Trials{trialIndex}.LetType,'NEG')) & ~isempty(strfind(char(Buttons.LetterNo),LetterResponse)))
                DisplayTrialAnswer = handles.LettersCorrect;
                [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3+FontSize, [0, 255, 0]);
            else
                DisplayTrialAnswer = 'Letters: ??';
                [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3+FontSize, [0, 0, 0]);
            end
        else
            DisplayTrialAnswer = handles.Letters.Timeout;
            [nx, ny, bbox] = DrawFormattedText(mainWindow, DisplayTrialAnswer, 'center', ScreenSize(2)/3+FontSize, [0, 0, 0]);
        end
        Screen('Flip',mainWindow,0);
    end
end
%% Final delay period
  WaitSecs('UntilTime',TrialTimes(1,1) + EndDelay);
% Clear the screen
%  Screen('Flip',mainWindow);
  WaitSecs(3);
%% Display thank you screen for five seconds.
[nx, ny, bbox] = DrawFormattedText(mainWindow, handles.ThankYouText, 'center', 'center', 0);
Screen('Flip',mainWindow);
WaitSecs(3)
Screen('Flip',mainWindow);
clc
sca
%% Create experimental descriptions 
ExperimentParameters = {};
ExperimentParameters.subid = demog.subid;
ExperimentParameters.Age = demog.Age;
ExperimentParameters.Sex = demog.Sex;
ExperimentParameters.dob = demog.dob;

ExperimentParameters.date = date;
ExperimentParameters.Timings = {};
ExperimentParameters.Timings.IntroDelay = IntroDelay;
ExperimentParameters.Timings.EncodeTime =EncodeTime;
ExperimentParameters.Timings.PreRetTime = PreRetTime;
ExperimentParameters.Timings.RetentionTime = RetentionTime;
ExperimentParameters.Timings.PostRetTime = PostRetTime;
ExperimentParameters.Timings.ProbeTime = ProbeTime;
ExperimentParameters.RunConditions = {};
ExperimentParameters.RunConditions.PresentInstructionsFlag = PresentInstructionsFlag;
ExperimentParameters.RunConditions.FeedbackFlag = FeedbackFlag;
ExperimentParameters.RunConditions.NumberListLength = NumberListLength;
ExperimentParameters.RunConditions.NRepeats = NRepeats;
ExperimentParameters.RunConditions.NoNumbersFlag = NoNumbersFlag;
ExperimentParameters.RunConditions.MRITrigger = Trigger2;
ExperimentParameters.Buttons = Buttons;
ExperimentParameters.Design = Design;
ExperimentParameters.OutFilePath = OutFilePath;
%% Calculate Times
for i = 1:NTrials
    Trials{i}.EncodeStartTime       = TrialTimes(i + 2,1) - TrialTimes(1,1);
    Trials{i}.PreRetStartTime       = TrialTimes(i + 2,2) - TrialTimes(1,1);
    Trials{i}.RetentionStartTime    = TrialTimes(i + 2,3) - TrialTimes(1,1);
    Trials{i}.PostRetStartTime      = TrialTimes(i + 2,4) - TrialTimes(1,1);
    Trials{i}.ProbeStartTime        = TrialTimes(i + 2,5) - TrialTimes(1,1);
    Trials{i}.ITIStartTime          = TrialTimes(i + 2,6) - TrialTimes(1,1);
    Trials{i}.ITIDuration           = ITI(i);
end
% The Trials structure is needed for the COrrectResponses program
ExperimentParameters.Trials = Trials;
% ---------------------------------------------------------
% Calculate performance
% This proram updates the Trials structure
[Trials Results] = subfnCorrectResponses_LetNum(ExperimentParameters);
ExperimentParameters.Trials = Trials;
ExperimentParameters.Results = Results;

OutString = '';
for i = 1:length(LoadLevels)
%     fprintf(1,'%d %-30s %0.2f\n',LoadLevels(i),'letter accuracy',Results{LoadLevels(i)}.LetterAccuracy);
%     fprintf(1,'%d %-30s %d\n',LoadLevels(i),'letter trials attempted',Results{LoadLevels(i)}.LetterCount);
%     fprintf(1,'%d %-30s %d\n',LoadLevels(i),'letter trials time-out',Results{LoadLevels(i)}.LetterTO);
%     fprintf(1,'--------------------------------------\n')

    OutString = [OutString sprintf('%dLet:Acc=%2.0f%%,TO=%2.0f%%; ', LoadLevels(i),100*Results{LoadLevels(i)}.Let_All_Acc,100*Results{LoadLevels(i)}.Let_All_propTO)];
end

OutString=[OutString sprintf('Low#:Acc=%2.0f%%;',100*Results{99}.Num_Low_All_Acc)];
OutString=[OutString sprintf('High#:Acc=%2.0f%%;',100*Results{99}.Num_High_All_Acc)];
OutString=[OutString sprintf('#Low TO=%2.0f%%',100*Results{99}.Num_Low_All_propTO)];
OutString=[OutString sprintf('#High TO=%2.0f%%',100*Results{99}.Num_High_All_propTO)];
% 
% fprintf(1,'--------------------------------------\n')
% fprintf(1,'%-32s %0.2f\n','Easy number accuracy',Results{99}.NumberLowAccuracy);
% fprintf(1,'%-32s %d\n','Easy number attempted',Results{99}.NumberLowCount);
% fprintf(1,'%-32s %0.2f\n','Hard number accuracy',Results{99}.NumberHighAccuracy);
% fprintf(1,'%-32s %d\n','Hard number attempted',Results{99}.NumberHighCount);
% fprintf(1,'%-32s %d\n','Number trials time-out',Results{99}.NumberTO);
% fprintf(1,'--------------------------------------\n')


% ---------------------------------------------------------
% Save data to file
str =  ['save(OutFilePath,''ExperimentParameters'')'];
% ['save OutFilePath'  ' ExperimentParameters'];
eval(str)
% ---------------------------------------------------------
%TrialTimes2 = zeros(size(TrialTimes));
% TrialTimes2 = [];
% TrialTimes2(1,1) = TrialTimes(2,1) - TrialTimes(1,1);
% for i = 1:size(TrialTimes,1)-1
%     for j = 2:size(TrialTimes,2)
%         TrialTimes2(i,j) = TrialTimes(i+1,j) - TrialTimes(i+1,j-1);
%     end
% end
% TrialTimes2
% % 
% NumString = '';
% for i = 1:length(NumLists{1}.HighList)
%     NumString = [ NumLists{1}.HighList(i) ' '];
% end
% NumString = [NumString '= ' NumLists{1}.HighListPOS];


%% Quick response checker
%     temp = max(Trials{trialIndex}.LetterResponseTime>-99)
%     if (~isempty(strfind(Trials{trialIndex}.LetType,'POS')) & strcmp(Trials{trialIndex}.LetterResponseButton(temp),Buttons.LetterNo)) || ...
%             (~isempty(strfind(Trials{trialIndex}.LetType,'NEG')) & strcmp(Trials{trialIndex}.LetterResponseButton(temp),Buttons.LetterYes))
%         DisplayTrialAnswer = 'Incorrect';
%     elseif (~isempty(strfind(Trials{trialIndex}.LetType,'POS')) & strcmp(Trials{trialIndex}.LetterResponseButton(temp),Buttons.LetterYes)) || ...
%             (~isempty(strfind(Trials{trialIndex}.LetType,'NEG')) & strcmp(Trials{trialIndex}.LetterResponseButton(temp),Buttons.LetterNo))
%         DisplayTrialAnswer = 'Correct';
%     else
%         DisplayTrialAnswer = 'Unknown Response';
%     end
%     fprintf(1,'%s\n',DisplayTrialAnswer);