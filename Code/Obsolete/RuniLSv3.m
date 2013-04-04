function varargout = RuniLSv3(varargin)
% RUNILSV3 MATLAB code for RuniLSv3.fig
%      RUNILSV3, by itself, creates a new RUNILSV3 or raises the existing
%      singleton*.
%
%      H = RUNILSV3 returns the handle to a new RUNILSV3 or the handle to
%      the existing singleton*.
%
%      RUNILSV3('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNILSV3.M with the given input arguments.
%
%      RUNILSV3('Property','Value',...) creates a new RUNILSV3 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RuniLSv3_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RuniLSv3_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Runirt///zzzzLSv2

% Last Modified by GUIDE v2.5 29-Aug-2011 15:06:09

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RuniLSv3_OpeningFcn, ...
    'gui_OutputFcn',  @RuniLSv3_OutputFcn, ...
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


% --- Executes just before RuniLSv3 is made visible.
function RuniLSv3_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RuniLSv3 (see VARARGIN)

% Choose default command line output for RuniLSv3
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RuniLSv3 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.output = hObject;
% Set some FIXED parameters
handles.FontSize = 60;
% Get the number and letter lists from the pull down menus
handles.NumList = get(handles.NumLen1,'String')
handles.LetList = get(handles.LetLoad1,'String')
handles.BlockList = get(handles.NumBlocks1,'String')
% Store these new values into the GUI data so they can be retrieved 
% elsewhere in the program
guidata(hObject,handles);
set(handles.subidText,'String','');
set(handles.Run1Text,'String','');



% Set up the initial values
set(handles.LetLoad1,'Value',3);
set(handles.NumLen1,'Value',1);
set(handles.NumBlocks1,'Value',1);
set(handles.FB1,'Value',1);
set(handles.Instr1,'Value',1);
set(handles.run1Success,'Value',0);
set(handles.scan1,'Value',0)

set(handles.LetLoad2,'Value',1);
set(handles.NumLen2,'Value',5);
set(handles.NumBlocks2,'Value',1);
set(handles.FB2,'Value',1);
set(handles.Instr2,'Value',0);
set(handles.run2Success,'Value',0);
set(handles.scan2,'Value',0)

set(handles.LetLoad3,'Value',3);
set(handles.NumLen3,'Value',5);
set(handles.NumBlocks3,'Value',1);
set(handles.FB3,'Value',1);
set(handles.Instr3,'Value',0);
set(handles.run3Success,'Value',0);
set(handles.scan3,'Value',0)

set(handles.LetLoad4,'Value',3);
set(handles.NumLength4,'Value',5);
set(handles.NumBlocks4,'Value',2);
set(handles.FB4,'Value',0);
set(handles.Instr4,'Value',0);
set(handles.run4Success,'Value',0);
set(handles.scan4,'Value',1)

set(handles.LetLoad5,'Value',3);
set(handles.NumLen5,'Value',5);
set(handles.NumBlocks5,'Value',2);
set(handles.FB5,'Value',0);
set(handles.Instr5,'Value',0);
set(handles.run5Success,'Value',0);
set(handles.scan5,'Value',1)

set(handles.LetLoad6,'Value',3);
set(handles.NumLen6,'Value',5);
set(handles.NumBlocks6,'Value',2);
set(handles.FB6,'Value',0);
set(handles.Instr6,'Value',0);
set(handles.run6Success,'Value',0);
set(handles.scan6,'Value',1)

% --- Outputs from this function are returned to the command line.
function varargout = RuniLSv3_OutputFcn(hObject, eventdata, handles)
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

% --- Executes on button press in Run1.
function Run1_Callback(hObject, eventdata, handles)
% hObject    handle to Run1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    if ~isempty(subid)
    set(handles.MessageBox,'String','');
    set(handles.Run1Text,'String','');
    Instr = get(handles.Instr1,'Value');
    FB = get(handles.FB1,'Value');
    if get(handles.scan1,'Value') == 1
        ITI = -1;
    else
        ITI = 2;
    end
    NumLen = str2num(char(handles.NumList(get(handles.NumLen1,'Value'))))
    NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks1,'Value'))))
    LetLoad = str2num(char(handles.LetList(get(handles.LetLoad1,'Value'))))
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        Instr,FB,NumLen,NumBlocks,LetLoad);
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
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end
% --- Executes on button press in Run2.
function Run2_Callback(hObject, eventdata, handles)
% hObject    handle to Run2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    if ~isempty(subid)
    set(handles.MessageBox,'String','');
    set(handles.Run2Text,'String','');
    Instr = get(handles.Instr2,'Value');
    FB = get(handles.FB2,'Value');
    if get(handles.scan2,'Value') == 1
        ITI = -1;
    else
        ITI = 2;
    end
    NumLen = str2num(char(handles.NumList(get(handles.NumLen2,'Value'))))
    NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks2,'Value'))))
    LetLoad = str2num(char(handles.LetList(get(handles.LetLoad2,'Value'))))
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        Instr,FB,NumLen,NumBlocks,LetLoad);
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
end

% --- Executes on button press in Run3.
function Run3_Callback(hObject, eventdata, handles)
% hObject    handle to Run3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    if ~isempty(subid)
    set(handles.MessageBox,'String','');
    set(handles.Run3Text,'String','');
    Instr = get(handles.Instr3,'Value');
    FB = get(handles.FB3,'Value');
    if get(handles.scan3,'Value') == 1
        ITI = -1;
    else
        ITI = 2;
    end
    NumLen = str2num(char(handles.NumList(get(handles.NumLen3,'Value'))))
    NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks3,'Value'))))
    LetLoad = str2num(char(handles.LetList(get(handles.LetLoad3,'Value'))))
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        Instr,FB,NumLen,NumBlocks,LetLoad);
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
% --- Executes on button press in Run4.
function Run4_Callback(hObject, eventdata, handles)
% hObject    handle to Run4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    if ~isempty(subid)
    set(handles.MessageBox,'String','');
    set(handles.Run4Text,'String','');
    Instr = get(handles.Instr4,'Value');
    FB = get(handles.FB4,'Value');
    if get(handles.scan4,'Value') == 1
        ITI = -1;
    else
        ITI = 2;
    end
    NumLen = str2num(char(handles.NumList(get(handles.NumLen4,'Value'))))
    NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks4,'Value'))))
    LetLoad = str2num(char(handles.LetList(get(handles.LetLoad4,'Value'))))
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        Instr,FB,NumLen,NumBlocks,LetLoad);
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
% --- Executes on button press in Run5.
function Run5_Callback(hObject, eventdata, handles)
% hObject    handle to Run5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    if ~isempty(subid)
    set(handles.MessageBox,'String','');
    set(handles.Run5Text,'String','');
    Instr = get(handles.Instr5,'Value');
    FB = get(handles.FB5,'Value');
    if get(handles.scan5,'Value') == 1
        ITI = -1;
    else
        ITI = 2;
    end
    NumLen = str2num(char(handles.NumList(get(handles.NumLen5,'Value'))))
    NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks5,'Value'))))
    LetLoad = str2num(char(handles.LetList(get(handles.LetLoad5,'Value'))))
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        Instr,FB,NumLen,NumBlocks,LetLoad);
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

% --- Executes on button press in Run6.
function Run6_Callback(hObject, eventdata, handles)
% hObject    handle to Run6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    if ~isempty(subid)
    set(handles.MessageBox,'String','');
    set(handles.Run6Text,'String','');
    Instr = get(handles.Instr6,'Value');
    FB = get(handles.FB6,'Value');
    if get(handles.scan6,'Value') == 1
        ITI = -1;
    else
        ITI = 2;
    end
    NumLen = str2num(char(handles.NumList(get(handles.NumLen6,'Value'))))
    NumBlocks = str2num(char(handles.BlockList(get(handles.NumBlocks6,'Value'))))
    LetLoad = str2num(char(handles.LetList(get(handles.LetLoad6,'Value'))))
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        Instr,FB,NumLen,NumBlocks,LetLoad);
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
function run4Success_Callback(hObject, eventdata, handles)
% hObject    handle to run3Success (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run3Success


% --- Executes on button press in run4Success.
function run5Success_Callback(hObject, eventdata, handles)
% hObject    handle to run4Success (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run4Success
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
 


% --- Executes on selection change in LetLoad1.
function LetLoad1_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad1


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


% --- Executes on selection change in NumLen1.
function NumLen1_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen1


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


% --- Executes on selection change in NumBlocks1.
function NumBlocks1_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks1


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


% --- Executes on selection change in NumBlocks2.
function NumBlocks2_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks2


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


% --- Executes on selection change in NumLen2.
function NumLen2_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen2


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


% --- Executes on selection change in LetLoad2.
function LetLoad2_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad2 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad2


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



% --- Executes on button press in Instr5.
function Instr5_Callback(hObject, eventdata, handles)
% hObject    handle to Instr5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr5


% --- Executes on button press in FB5.
function FB5_Callback(hObject, eventdata, handles)
% hObject    handle to FB5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB5


% --- Executes on selection change in NumBlocks5.
function NumBlocks5_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks5


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


% --- Executes on selection change in NumLen5.
function NumLen5_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen5


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


% --- Executes on selection change in LetLoad5.
function LetLoad5_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad5 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad5


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


% --- Executes on selection change in LetLoad4.
function LetLoad4_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad4


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


% --- Executes on selection change in NumLength4.
function NumLength4_Callback(hObject, eventdata, handles)
% hObject    handle to NumLength4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLength4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLength4


% --- Executes during object creation, after setting all properties.
function NumLength4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumLength4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in NumBlocks4.
function NumBlocks4_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks4 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks4


% --- Executes during object creation, after setting all properties.
function NumBlocks4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumBlocks4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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


% --- Executes on button press in Instr4.
function Instr4_Callback(hObject, eventdata, handles)
% hObject    handle to Instr4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr4



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



% --- Executes on selection change in LetLoad3.
function LetLoad3_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad3


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


% --- Executes on selection change in NumLen3.
function NumLen3_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen3


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


% --- Executes on selection change in NumBlocks3.
function NumBlocks3_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks3


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


% --- Executes on button press in scan2.
function scan2_Callback(hObject, eventdata, handles)
% hObject    handle to scan2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scan2


% --- Executes on button press in scan5.
function scan5_Callback(hObject, eventdata, handles)
% hObject    handle to scan5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scan5


% --- Executes on button press in scan4.
function scan4_Callback(hObject, eventdata, handles)
% hObject    handle to scan4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scan4


% --- Executes on button press in scan3.
function scan3_Callback(hObject, eventdata, handles)
% hObject    handle to scan3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scan3


% --- Executes on button press in scan1.
function scan1_Callback(hObject, eventdata, handles)
% hObject    handle to scan1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scan1


% --- Executes on button press in scan6.
function scan6_Callback(hObject, eventdata, handles)
% hObject    handle to scan6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of scan6


% --- Executes on selection change in LetLoad6.
function LetLoad6_Callback(hObject, eventdata, handles)
% hObject    handle to LetLoad6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns LetLoad6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from LetLoad6


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


% --- Executes on selection change in NumLen6.
function NumLen6_Callback(hObject, eventdata, handles)
% hObject    handle to NumLen6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumLen6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumLen6


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


% --- Executes on selection change in NumBlocks6.
function NumBlocks6_Callback(hObject, eventdata, handles)
% hObject    handle to NumBlocks6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns NumBlocks6 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from NumBlocks6


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


% --- Executes on button press in FB6.
function FB6_Callback(hObject, eventdata, handles)
% hObject    handle to FB6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of FB6


% --- Executes on button press in Instr6.
function Instr6_Callback(hObject, eventdata, handles)
% hObject    handle to Instr6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of Instr6


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


% --------------------------------------------------------------------
function Defaults_Callback(hObject, eventdata, handles)
% hObject    handle to Defaults (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
