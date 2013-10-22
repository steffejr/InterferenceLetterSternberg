% Feedback      (2 blocks 48 trials each, Random ITI)
% There is a pause and a get ready screen between blocks.
% No Feedback   (1 block 48 trials each, Random ITI)
% Scanner       (2 blocks 48 trials each)
%
% With instructions and feedback
% Z1234     = No
% ?/5678    = Yes
% There is a typo in the instructions
% Have it so it runs the three feedback runs with only a pause in between.
% Provide some feedback to the experimenter, but not tpo much to the
% subject. They do not need to know exact performance. Leave that to the
% experimenter to interpret what to say.

ITIValue = 2;
NRepeats = 3;
LoadLevels = [1 3 6];

PresentInstructionsFlag = 0;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 0;               % Present feedback? 1=yes, 0=no
NumberListLength = 0;
NoNumbersFlag = 0; % The option is given to NOT show the numbers but only the fixation cross.
subid = 'JS_Real'

FontSize=40;
demog = {};
demog.subid = subid;
[ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, FontSize, ITIValue,PresentInstructionsFlag,FeedbackFlag,NumberListLength,NRepeats,LoadLevels)



ITIValue = 2;
NRepeats = 1;
LoadLevels = [2 6];
PresentInstructionsFlag = 0;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 1;               % Present feedback? 1=yes, 0=no
NumberListLength = 4;
NoNumbersFlag = 1; % The option is given to NOT show the numbers but only the fixation cross.
subid = 'test'
FontSize=40;
[ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, FontSize, ITIValue,PresentInstructionsFlag,FeedbackFlag,NumberListLength,NRepeats,NoNumbersFlag,LoadLevels)


ITIValue = 2;
NRepeats = 1;
LoadLevels = [1 1];
PresentInstructionsFlag = 0;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 1;               % Present feedback? 1=yes, 0=no
NumberListLength = 4;
NoNumbersFlag = 0; % The option is given to NOT show the numbers but only the fixation cross.
subid = 'test'
FontSize=40;
[ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, FontSize, ITIValue,PresentInstructionsFlag,FeedbackFlag,NumberListLength,NRepeats,NoNumbersFlag,LoadLevels)

ITIValue = 2;
NRepeats = 1;
LoadLevels = [2 6];
PresentInstructionsFlag = 0;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 1;               % Present feedback? 1=yes, 0=no
NumberListLength = 4;
NoNumbersFlag = 0; % The option is given to NOT show the numbers but only the fixation cross.
subid = 'test'
FontSize=40;
[ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, FontSize, ITIValue,PresentInstructionsFlag,FeedbackFlag,NumberListLength,NRepeats,NoNumbersFlag,LoadLevels)








