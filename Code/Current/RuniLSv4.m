function varargout = RuniLSv4(varargin)
% RUNILSV4 MATLAB code for RuniLSv4.fig
%      RUNILSV4, by itself, creates a new RUNILSV4 or raises the existing
%      singleton*.
%
%      H = RUNILSV4 returns the handle to a new RUNILSV4 or the handle to
%      the existing singleton*.
%
%      RUNILSV4('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNILSV4.M with the given input arguments.
%
%      RUNILSV4('Property','Value',...) creates a new RUNILSV4 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RuniLSv4_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RuniLSv4_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Runirt///zzzzLSv2

% Last Modified by GUIDE v2.5 01-Jun-2016 19:33:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RuniLSv4_OpeningFcn, ...
    'gui_OutputFcn',  @RuniLSv4_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before RuniLSv4 is made visible.
function RuniLSv4_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RuniLSv4 (see VARARGIN)

% Choose default command line output for RuniLSv4
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RuniLSv4 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.output = hObject;
% Set some FIXED parameters
% NOW IN CONFIG FILE handles.FontSize = 60;
% NOW IN CONFIG FILE handles.Trigger = '';
% Get the number and letter lists from the pull down menus
handles.NumList = get(handles.NumLen1,'String');
handles.LetList = get(handles.LetLoad1,'String');
handles.BlockList = get(handles.NumBlocks1,'String');
handles.SexList = {'' 'M' 'F'};
handles.dob = -99;
% Store these new values into the GUI data so they can be retrieved
% elsewhere in the program
guidata(hObject,handles);
set(handles.subidText,'String','');
set(handles.Run1Text,'String','');

%% Read Config File
s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);

%[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config.txt'),handles);
[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Modified_Config.txt'),handles);
DefaultModifiedDIR(handles)
set(handles.InterferencePilot,'Checked','off')
set(handles.PILOT,'Checked','off')
set(handles.ZeroAll,'Checked','off')
set(handles.Modified,'Checked','on')   
   
guidata(hObject, handles);
% Set up the initial values
% switch handles.Location
%     case 'Columbia'
%         DefaultInterferenceDIR(handles);
%         set(handles.InterferencePilot,'Checked','on')
%     case 'Montpellier'
%         DefaultMontpellierDIR(handles)
%         set(handles.Montpellier,'Checked','on')
%     case 'PILOT'
         
%     otherwise
%         DefaultZeroValues(handles)
% end
set(handles.figure1,'Name',[handles.Location ':' handles.Function]);
% Check the screen resolution
CurrentScreenRes = get(0,'ScreenSize');
if handles.ScreenResolution ~= -1
    if sum(CurrentScreenRes(3:4) == handles.ScreenResolution) == 2
        % The screen is the right resolution
    else
        STR = sprintf('Please change the screen resolution to: %d by %d',...
            handles.ScreenResolution(1),handles.ScreenResolution(2));
       % warndlg(STR)
    end
end

%% Setup date of birth selector
%jPanel = com.jidesoft.combobox.DateComboBox;
%[hPanel,hContainer] = javacomponent(jPanel,[200,688,100,20],gcf)

% --- Outputs from this function are returned to the command line.
function varargout = RuniLSv4_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% if isempty(get(handles.subidText,'String'))
%     set(handles.MessageBox,'String','Please enter subject ID');
% else
%
% end
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RUN 1 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Run1.
function Run1_Callback(hObject, eventdata, handles)
% hObject    handle to Run1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    set(handles.MessageBox,'String','');
    demog = {};
    demog.subid = get(handles.subidText,'String');
    %demog.Age = get(handles.Age,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'Train1';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run1Text,'String','');
        Instr = get(handles.Instr1,'Value');
        FB = get(handles.FB1,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen1,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks1,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad1,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad1,'Value'))));
        %LetLoad = str2num(char(handles.LetList(get(handles.LetLoad1,'Value'))));
        % I need some way to say which run this is. I am using the demog
        % structure since it already exists.
        demog.RunNumber = 'Training1';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run1Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run1Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message ...
            ', ' me.stack(1).name '; line: ' num2str(me.stack(1).line)];
        set(handles.MessageBox,'String',ErrorString);
        me.stack(1)
    end
    handles.output = me.message;
end
% --- Executes on selection change in LetLoad1.
function LetLoad1_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad1

% The following updates the text on the GUI showingthe number of trials
% that result from the choices selected.

NumTrials1 = sufnCalcNumberOfTrials(handles,handles.LetLoad1,...
    get(handles.NumLen1,'Value'),...
    get(handles.NumBlocks1,'Value'));

set(handles.NumTrials1,'String',num2str(NumTrials1));
% --- Executes on selection change in NumLen1.
function NumLen1_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen1
% The following updates the text on the GUI showingthe number of trials
% that result from the choices selected.
NumTrials1 = sufnCalcNumberOfTrials(handles,handles.LetLoad1,...
    get(handles.NumLen1,'Value'),...
    get(handles.NumBlocks1,'Value'));
handles.Trigger2

set(handles.NumTrials1,'String',num2str(NumTrials1));
% --- Executes on selection change in NumBlocks1.
function NumBlocks1_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks1
NumTrials1 = sufnCalcNumberOfTrials(handles,handles.LetLoad1,...
    get(handles.NumLen1,'Value'),...
    get(handles.NumBlocks1,'Value'));

set(handles.NumTrials1,'String',num2str(NumTrials1));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN 2 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Run2.
function Run2_Callback(hObject, eventdata, handles)
% hObject    handle to Run2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'Train2';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run2Text,'String','');
        Instr = get(handles.Instr2,'Value');
        FB = get(handles.FB2,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen2,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks2,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad2,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad2,'Value'))));
        demog.RunNumber = 'Training2';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run2Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run2Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
    fid = fopen('ERRORLOG.txt','a');
    fprintf(fid,'%s\n%s\n\n',datestr(now),me.message);
    fclose(fid);
end
% --- Executes on selection change in NumBlocks2.
function NumBlocks2_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks2
NumTrials2 = sufnCalcNumberOfTrials(handles,handles.LetLoad2,...
    get(handles.NumLen2,'Value'),...
    get(handles.NumBlocks2,'Value'));

set(handles.NumTrials2,'String',num2str(NumTrials2));
% --- Executes on selection change in LetLoad2.
function LetLoad2_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad2
NumTrials2 = sufnCalcNumberOfTrials(handles,handles.LetLoad2,...
    get(handles.NumLen2,'Value'),...
    get(handles.NumBlocks2,'Value'));

set(handles.NumTrials2,'String',num2str(NumTrials2));
% --- Executes on selection change in NumLen2.
function NumLen2_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen2
NumTrials2 = sufnCalcNumberOfTrials(handles,handles.LetLoad2,...
    get(handles.NumLen2,'Value'),...
    get(handles.NumBlocks2,'Value'));

set(handles.NumTrials2,'String',num2str(NumTrials2));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN 3 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Run3.
function Run3_Callback(hObject, eventdata, handles)
% hObject    handle to Run3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'Train3';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run3Text,'String','');
        Instr = get(handles.Instr3,'Value');
        FB = get(handles.FB3,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen3,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks3,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad3,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad3,'Value'))));
        demog.RunNumber = 'Training3';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run3Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run3Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end
% --- Executes on selection change in LetLoad3.
function LetLoad3_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad3
NumTrials3 = sufnCalcNumberOfTrials(handles,handles.LetLoad3,...
    get(handles.NumLen3,'Value'),...
    get(handles.NumBlocks3,'Value'));

set(handles.NumTrials3,'String',num2str(NumTrials3));
% --- Executes on selection change in NumBlocks3.
function NumBlocks3_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks3
NumTrials3 = sufnCalcNumberOfTrials(handles,handles.LetLoad3,...
    get(handles.NumLen3,'Value'),...
    get(handles.NumBlocks3,'Value'));

set(handles.NumTrials3,'String',num2str(NumTrials3));
% --- Executes on selection change in NumLen3.
function NumLen3_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen3
NumTrials3 = sufnCalcNumberOfTrials(handles,handles.LetLoad3,...
    get(handles.NumLen3,'Value'),...
    get(handles.NumBlocks3,'Value'));

set(handles.NumTrials3,'String',num2str(NumTrials3));


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN 4 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Run4.
function Run4_Callback(hObject, eventdata, handles)
% hObject    handle to Run4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'Train4';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run4Text,'String','');
        Instr = get(handles.Instr4,'Value');
        FB = get(handles.FB4,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen4,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks4,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad4,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad4,'Value'))));
        demog.RunNumber = 'Training4';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run4Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run4Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end
% --- Executes on selection change in LetLoad4.
function LetLoad4_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NumTrials4 = sufnCalcNumberOfTrials(handles,handles.LetLoad4,...
    get(handles.NumLen4,'Value'),...
    get(handles.NumBlocks4,'Value'));

set(handles.NumTrials4,'String',num2str(NumTrials4));
% --- Executes on selection change in NumBlocks5.
function NumBlocks4_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks5
NumTrials4 = sufnCalcNumberOfTrials(handles,handles.LetLoad4,...
    get(handles.NumLen4,'Value'),...
    get(handles.NumBlocks4,'Value'));

set(handles.NumTrials4,'String',num2str(NumTrials4));
% --- Executes on selection change in NumLen4.
function NumLen4_Callback(hObject, eventdata, handles)

% hObject    handle to NumLen4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
NumTrials4 = sufnCalcNumberOfTrials(handles,handles.LetLoad4,...
    get(handles.NumLen4,'Value'),...
    get(handles.NumBlocks4,'Value'));

set(handles.NumTrials4,'String',num2str(NumTrials4));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN 5 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Run5.
function Run5_Callback(hObject, eventdata, handles)
% hObject    handle to Run5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'MRI1';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run5Text,'String','');
        Instr = get(handles.Instr5,'Value');
        FB = get(handles.FB5,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen5,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks5,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad5,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad5,'Value'))));
        demog.RunNumber = 'MRI1';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run5Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run5Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end
% --- Executes on selection change in NumBlocks5.
function NumBlocks5_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks5
NumTrials5 = sufnCalcNumberOfTrials(handles,handles.LetLoad5,...
    get(handles.NumLen5,'Value'),...
    get(handles.NumBlocks5,'Value'));

set(handles.NumTrials5,'String',num2str(NumTrials5));
% --- Executes on selection change in NumLen5.
function NumLen5_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen5
NumTrials5 = sufnCalcNumberOfTrials(handles,handles.LetLoad5,...
    get(handles.NumLen5,'Value'),...
    get(handles.NumBlocks5,'Value'));

set(handles.NumTrials5,'String',num2str(NumTrials5));
% --- Executes on selection change in LetLoad5.
function LetLoad5_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad5
NumTrials5 = sufnCalcNumberOfTrials(handles,handles.LetLoad5,...
    get(handles.NumLen5,'Value'),...
    get(handles.NumBlocks5,'Value'));

set(handles.NumTrials5,'String',num2str(NumTrials5));

%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN 6 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Run6.
function Run6_Callback(hObject, eventdata, handles)
% hObject    handle to Run6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'MRI2';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run6Text,'String','');
        Instr = get(handles.Instr6,'Value');
        FB = get(handles.FB6,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen6,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks6,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad6,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad6,'Value'))));
        demog.RunNumber = 'MRI2';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run6Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run6Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end
% --- Executes on selection change in NumLen6.
function NumLen6_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen6
NumTrials6 = sufnCalcNumberOfTrials(handles,handles.LetLoad6,...
    get(handles.NumLen6,'Value'),...
    get(handles.NumBlocks6,'Value'));

set(handles.NumTrials6,'String',num2str(NumTrials6));
% --- Executes on selection change in NumBlocks6.
function NumBlocks6_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% --- Executes on selection change in LetLoad6.
NumTrials6 = sufnCalcNumberOfTrials(handles,handles.LetLoad6,...
    get(handles.NumLen6,'Value'),...
    get(handles.NumBlocks6,'Value'));

set(handles.NumTrials6,'String',num2str(NumTrials6));
function LetLoad6_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad6
NumTrials6 = sufnCalcNumberOfTrials(handles,handles.LetLoad6,...
    get(handles.NumLen6,'Value'),...
    get(handles.NumBlocks6,'Value'));

set(handles.NumTrials6,'String',num2str(NumTrials6));
%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% RUN 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes on button press in Run7.
function Run7_Callback(hObject, eventdata, handles)
% hObject    handle to Run7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'MRI3';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run7Text,'String','');
        Instr = get(handles.Instr7,'Value');
        FB = get(handles.FB7,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen7,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks7,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad7,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad7,'Value'))));
        demog.RunNumber = 'MRI3';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run7Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run7Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end
% --- Executes on selection change in NumBlocks7.
function NumBlocks7_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks7
NumTrials7 = sufnCalcNumberOfTrials(handles,handles.LetLoad7,...
    get(handles.NumLen7,'Value'),...
    get(handles.NumBlocks7,'Value'));

set(handles.NumTrials7,'String',num2str(NumTrials7));
% --- Executes on selection change in LetLoad7.

function LetLoad7_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad7
NumTrials7 = sufnCalcNumberOfTrials(handles,handles.LetLoad7,...
    get(handles.NumLen7,'Value'),...
    get(handles.NumBlocks7,'Value'));
set(handles.NumTrials7,'String',num2str(NumTrials7));

% --- Executes on selection change in NumLen7.
function NumLen7_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen7
NumTrials7 = sufnCalcNumberOfTrials(handles,handles.LetLoad7,...
    get(handles.NumLen7,'Value'),...
    get(handles.NumBlocks7,'Value'));

set(handles.NumTrials7,'String',num2str(NumTrials7));


%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function Run1Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run1Text as text
%        str2double(get(hObject,'String')) returns contents of Run1Text as a double


% --- Executes during object creation, after setting all properties.
function Run1Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run1Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function MessageBox_Callback(hObject, eventdata, handles)
% hObject    handle to MessageBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MessageBox as text
%        str2double(get(hObject,'String')) returns contents of MessageBox as a double

% --- Executes during object creation, after setting all properties.
function MessageBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MessageBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in run2Success.
function run2Success_Callback(hObject, eventdata, handles)
% hObject    handle to run2Success (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run2Success

% --- Executes on button press in run2Success.
function run3Success_Callback(hObject, eventdata, handles)
% hObject    handle to run2Success (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run2Success


% --- Executes on button press in run3Success.
function run5Success_Callback(hObject, eventdata, handles)
% hObject    handle to run3Success (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run3Success

% --- Executes on button press in run5Success.
function run6Success_Callback(hObject, eventdata, handles)
% hObject    handle to run5Success (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run5Success
% --- Executes on button press in redoRun1.

function Run3ScanText_Callback(hObject, eventdata, handles)
% hObject    handle to Run3ScanText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run3ScanText as text
%        str2double(get(hObject,'String')) returns contents of Run3ScanText as a double

function subidText_Callback(hObject, eventdata, handles)
% hObject    handle to subidText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of subidText as text
%        str2double(get(hObject,'String')) returns contents of subidText as a double

% --- Executes during object creation, after setting all properties.
function subidText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to subidText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in exit.
function exit_Callback(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
ExitQuestion = questdlg('Are you sure you want to exit?','','Yes','No','No');
if ~isempty(strmatch(ExitQuestion,'Yes'))
    exit;
end

% --- Executes on button press in commit.
function commit_Callback(hObject, eventdata, handles)
% hObject    handle to commit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
eval(['! C:\Documents and Settings\sf\Desktop\LetterSternbergWithInterference\Commit.bat'])

% --- Executes during object creation, after setting all properties.
function LetLoad1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NumLen1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NumBlocks1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in FB1.
function FB1_Callback(hObject, eventdata, handles)
% hObject    handle to FB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB1

% --- Executes on button press in Instr1.
function Instr1_Callback(hObject, eventdata, handles)
% hObject    handle to Instr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr1

function Run2Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run2Text as text
%        str2double(get(hObject,'String')) returns contents of Run2Text as a double

% --- Executes during object creation, after setting all properties.
function Run2Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run2Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in Instr2.
function Instr2_Callback(hObject, eventdata, handles)
% hObject    handle to Instr2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr2

% --- Executes on button press in FB2.
function FB2_Callback(hObject, eventdata, handles)
% hObject    handle to FB2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB2


% --- Executes during object creation, after setting all properties.
function NumBlocks2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NumLen2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function LetLoad2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Run6Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run6Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run6Text as text
%        str2double(get(hObject,'String')) returns contents of Run6Text as a double


% --- Executes during object creation, after setting all properties.
function Run6Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run6Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in Instr6.
function Instr6_Callback(hObject, eventdata, handles)
% hObject    handle to Instr6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr6


% --- Executes on button press in FB6.
function FB6_Callback(hObject, eventdata, handles)
% hObject    handle to FB6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB6



% --- Executes during object creation, after setting all properties.
function NumBlocks5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function NumLen6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function LetLoad6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function LetLoad5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function NumLen5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function NumBlocks4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FB5.
function FB5_Callback(hObject, eventdata, handles)
% hObject    handle to FB5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB5


% --- Executes on button press in Instr5.
function Instr5_Callback(hObject, eventdata, handles)
% hObject    handle to Instr5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr5



function Run5Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run5Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run5Text as text
%        str2double(get(hObject,'String')) returns contents of Run5Text as a double


% --- Executes during object creation, after setting all properties.
function Run5Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run5Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end





% --- Executes during object creation, after setting all properties.
function LetLoad3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function NumLen3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NumBlocks3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FB3.
function FB3_Callback(hObject, eventdata, handles)
% hObject    handle to FB3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB3


% --- Executes on button press in Instr3.
function Instr3_Callback(hObject, eventdata, handles)
% hObject    handle to Instr3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr3


% --- Executes on button press in Instr3.
function Instr4_Callback(hObject, eventdata, handles)
% hObject    handle to Instr3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr3



function Run3Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run3Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run3Text as text
%        str2double(get(hObject,'String')) returns contents of Run3Text as a double


% --- Executes during object creation, after setting all properties.
function Run3Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run3Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




% --- Executes during object creation, after setting all properties.
function LetLoad7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function NumLen7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function NumBlocks7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FB7.
function FB7_Callback(hObject, eventdata, handles)
% hObject    handle to FB7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB7

% --- Executes on button press in Instr7.
function Instr7_Callback(hObject, eventdata, handles)
% hObject    handle to Instr7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr7

function Run7Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run7Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run7Text as text
%        str2double(get(hObject,'String')) returns contents of Run7Text as a double


% --- Executes during object creation, after setting all properties.
function Run7Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run7Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Defaults_Callback(hObject, eventdata, handles)
% hObject    handle to Defaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function NumTrials1_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials1 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials1 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrials7_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials7 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials7 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrials2_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials2 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials2 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrials6_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials6 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials6 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrials5_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials5 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials5 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials5_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrials3_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials3 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials3 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Age_Callback(hObject, eventdata, handles)
% hObject    handle to Age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Age as text
%        str2double(get(hObject,'String')) returns contents of Age as a double


% --- Executes during object creation, after setting all properties.
function Age_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Age (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in Sex.
function Sex_Callback(hObject, eventdata, handles)
% hObject    handle to Sex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns Sex contents as cell array
%        contents{get(hObject,'Value')} returns selected item from Sex


% --- Executes during object creation, after setting all properties.
function Sex_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Sex (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
%% Setup menu bar
% --------------------------------------------------------------------
function InterferencePilot_Callback(hObject, eventdata, handles)
% hObject    handle to InterferencePilot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);

%[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config.txt'),handles);
[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config.txt'),handles);
DefaultInterferenceDIR(handles)
set(handles.PILOT,'Checked','on')
% This function modifies the handles structure by loading up a different
% onfig file. In order to passthis information back tp the main GUI the
% following function is required.
guidata(handles.figure1,handles)



% --------------------------------------------------------------------
function Montpellier_Callback(hObject, eventdata, handles)
% hObject    handle to Montpellier (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% TODO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
DefaultMontpellierDIR(handles)
set(handles.Montpellier,'Checked','on')
set(handles.InterferencePilot,'Checked','off')
set(handles.PILOT,'Checked','off')

% --------------------------------------------------------------------
function PILOT_Callback(hObject, eventdata, handles)
% hObject    handle to PILOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DefaultPILOTDIR(handles)
%set(handles.Montpellier,'Checked','off')
set(handles.InterferencePilot,'Checked','off')
set(handles.PILOT,'Checked','on')

s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);

%[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config.txt'),handles);
[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_PILOTConfig.txt'),handles);
DefaultPILOTDIR(handles)
set(handles.PILOT,'Checked','on')
set(handles.figure1,'Name',[handles.Location ':' handles.Function]);

% This function modifies the handles structure by loading up a different
% onfig file. In order to passthis information back tp the main GUI the
% following function is required.
guidata(handles.figure1,handles)
% --------------------------------------------------------------------
function Modified_Callback(hObject, eventdata, handles)
% hObject    handle to PILOT (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

s='';
eval('s=which(''RuniLSv4'');');
% check top make sure the output file is there, if not then create it
ProgramPath = fileparts(s);
ProgramPath = fileparts(ProgramPath);
ProgramPath = fileparts(ProgramPath);

%[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Config.txt'),handles);
[handles] = subfnReadConfigFile(fullfile(ProgramPath,'ConfigFiles','iLS_Modified_Config.txt'),handles);
DefaultModifiedDIR(handles)

set(handles.PILOT,'Checked','off')
set(handles.InterferencePilot,'Checked','off')
set(handles.ZeroAll,'Checked','off')
set(handles.Modified,'Checked','on')
set(handles.figure1,'Name',[handles.Location ':' handles.Function]);

% This function modifies the handles structure by loading up a different
% onfig file. In order to passthis information back tp the main GUI the
% following function is required.
guidata(handles.figure1,handles)

% --------------------------------------------------------------------
function ZeroAll_Callback(hObject, eventdata, handles)
% hObject    handle to ZeroAll (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
DefaultZeroValues(handles)
set(handles.InterferencePilot,'Checked','off')
%set(handles.Montpellier,'Checked','off')


% --- Executes on selection change in LetLoad5.
function popupmenu24_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad5


% --- Executes during object creation, after setting all properties.
function popupmenu24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function NumLen4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))

    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NumBlocks5.
function popupmenu26_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks5


% --- Executes during object creation, after setting all properties.
function popupmenu26_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FB5.
function checkbox19_Callback(hObject, eventdata, handles)
% hObject    handle to FB5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB5


% --- Executes on button press in Instr5.
function checkbox20_Callback(hObject, eventdata, handles)
% hObject    handle to Instr5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr5


% --- Executes on button press in Run5.
function pushbutton20_Callback(hObject, eventdata, handles)
% hObject    handle to Run5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function edit23_Callback(hObject, eventdata, handles)
% hObject    handle to Run5Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run5Text as text
%        str2double(get(hObject,'String')) returns contents of Run5Text as a double


% --- Executes during object creation, after setting all properties.
function edit23_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run5Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit24_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials5 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials5 as a double


% --- Executes during object creation, after setting all properties.
function edit24_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function NumBlocks6_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function LetLoad4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Run4Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run4Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run4Text as text
%        str2double(get(hObject,'String')) returns contents of Run4Text as a double


% --- Executes during object creation, after setting all properties.
function Run4Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run4Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrials4_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials4 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials4 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FB4.
function FB4_Callback(hObject, eventdata, handles)
% hObject    handle to FB4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB4



    
    %set(handles.Trigger,'Value',evalin('base','Trigger'))
    %set(handles.Trigger,'Value','5');

% --------------------------------------------------------------------
function a_Callback(hObject, eventdata, handles)
% hObject    handle to a (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function activex2_Change(hObject, eventdata, handles)
% hObject    handle to activex2 (see GCBO)
% eventdata  structure with parameters passed to COM event listener
% handles    structure with handles and user data (see GUIDATA)
    age = CalculateAge(handles);
    set(handles.Age,'String',num2str(age));
    
function age = CalculateAge(handles)
    dob = returnDOB(handles);
    %dob = sprintf('%02d%02d%04d',handles.activex2.Month,handles.activex2.Day,handles.activex2.Year);
    handles.dob = dob;
    c = clock;
    today = sprintf('%02d%02d%04d',c(2),c(3),c(1));
    today_dn = datenum(str2num(today(5:8)),str2num(today(1:2)),str2num(today(3:4)));
    dob_dn = datenum(str2num(dob(5:8)),str2num(dob(1:2)),str2num(dob(3:4)));
    diff_dn = today_dn - dob_dn;
    age = floor(diff_dn/365);

function dob = returnDOB(handles)
    DOBMonth = get(handles.popupmenuMONTH,'value');
    DOBDay = get(handles.popupmenuDAY,'value');
    %get(handles.popupmenuDAY,'value')
    YearList = get(handles.popupmenuYEAR,'String');
    DOBYear = str2num(YearList{get(handles.popupmenuYEAR,'value')});
    dob = sprintf('%02d%02d%04d',DOBMonth,DOBDay,DOBYear);


% --- Executes on selection change in popupmenuYEAR.
function popupmenuYEAR_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuYEAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuYEAR contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuYEAR

    age = CalculateAge(handles);
    set(handles.Age,'String',num2str(age));
    
% --- Executes during object creation, after setting all properties.
function popupmenuYEAR_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuYEAR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuMONTH.
function popupmenuMONTH_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuMONTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuMONTH contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuMONTH

    age = CalculateAge(handles);
    set(handles.Age,'String',num2str(age));

% --- Executes during object creation, after setting all properties.
function popupmenuMONTH_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuMONTH (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenuDAY.
function popupmenuDAY_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenuDAY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenuDAY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenuDAY
    age = CalculateAge(handles);
    set(handles.Age,'String',num2str(age));


% --- Executes during object creation, after setting all properties.
function popupmenuDAY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenuDAY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function TempOrder_Callback(hObject, eventdata, handles)
% hObject    handle to TempOrder (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    if ~isempty(demog.subid)
        RunTempOrder(demog);
    else
        warndlg('Please enter a subject ID.')
    end



% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function FB1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FB1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Instr1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Instr1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function textLetLoad1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textLetLoad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function textNumLen_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textNumLen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function textNumBlock1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to textNumBlock1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --------------------------------------------------------------------
function Reload_Config_Callback(hObject, eventdata, handles)
% hObject    handle to Reload_Config (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    RuniLSv4_OpeningFcn(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Tools_Callback(hObject, eventdata, handles)
% hObject    handle to Tools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function CheckTiming_Callback(hObject, eventdata, handles)
% hObject    handle to CheckTiming (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    subfnCheckTiming


% --------------------------------------------------------------------
function DisplayResults_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayResults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    


% --------------------------------------------------------------------
function DisplayResultsMRI_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayResultsMRI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    subfnDisplayAllResults('MRI')

% --------------------------------------------------------------------
function DisplayResultsTraining_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayResultsTraining (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    subfnDisplayAllResults('Train')


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over exit.
function exit_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


function LetLoad8_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad7 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad7
NumTrials8 = sufnCalcNumberOfTrials(handles,handles.LetLoad8,...
    get(handles.NumLen8,'Value'),...
    get(handles.NumBlocks8,'Value'));
set(handles.NumTrials8,'String',num2str(NumTrials8));



% --- Executes during object creation, after setting all properties.
function LetLoad8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LetLoad8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NumBlocks8.
function NumBlocks8_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks8
NumTrials8 = sufnCalcNumberOfTrials(handles,handles.LetLoad8,...
    get(handles.NumLen8,'Value'),...
    get(handles.NumBlocks8,'Value'));
set(handles.NumTrials8,'String',num2str(NumTrials8));




% --- Executes during object creation, after setting all properties.
function NumBlocks8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in FB8.
function FB8_Callback(hObject, eventdata, handles)
% hObject    handle to FB8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB8


% --- Executes on button press in Instr8.
function Instr8_Callback(hObject, eventdata, handles)
% hObject    handle to Instr8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr8


% --- Executes on button press in Run8.
function Run8_Callback(hObject, eventdata, handles)
% hObject    handle to Run7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    demog = {};
    demog.subid = get(handles.subidText,'String');
    demog.Age = CalculateAge(handles);
    demog.Sex = handles.SexList{get(handles.Sex,'Value')};
    demog.dob = returnDOB(handles);
    demog.Tag = 'MRI4';
    if ~isempty(demog.subid)
        set(handles.MessageBox,'String','');
        set(handles.Run8Text,'String','');
        Instr = get(handles.Instr8,'Value');
        FB = get(handles.FB8,'Value');
        
        NumLen = str2num(char(handles.NumList(get(handles.NumLen8,'Value'))));
        NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks8,'Value'))));
        % This allows for dynamic updating of the letter lists from the
        % config files
        letList = get(handles.LetLoad8,'String');
        LetLoad = str2num(char(letList(get(handles.LetLoad8,'Value'))));
        demog.RunNumber = 'MRI4';
        [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(demog, ...
            Instr,FB,NumLen,NumBlocks,LetLoad,handles);
        set(handles.Run8Text,'String',OutString);
        % if all goes well, report a summary of performance and update the push button
        set(handles.run8Success,'Value',1);
    else
        warndlg('Please enter a subject ID.')
    end
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end




function Run8Text_Callback(hObject, eventdata, handles)
% hObject    handle to Run8Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run8Text as text
%        str2double(get(hObject,'String')) returns contents of Run8Text as a double


% --- Executes during object creation, after setting all properties.
function Run8Text_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run8Text (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrials8_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrials8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of NumTrials8 as text
%        str2double(get(hObject,'String')) returns contents of NumTrials8 as a double


% --- Executes during object creation, after setting all properties.
function NumTrials8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrials8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NumLen8.
function NumLen8_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen8 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen8


% --- Executes during object creation, after setting all properties.
function NumLen8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLen8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function Run8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Run7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
