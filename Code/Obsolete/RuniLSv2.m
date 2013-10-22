function varargout = RuniLSv2(varargin)
% RUNILSV2 MATLAB code for RuniLSv2.fig
%      RUNILSV2, by itself, creates a new RUNILSV2 or raises the existing
%      singleton*.
%
%      H = RUNILSV2 returns the handle to a new RUNILSV2 or the handle to
%      the existing singleton*.
%
%      RUNILSV2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNILSV2.M with the given input arguments.
%
%      RUNILSV2('Property','Value',...) creates a new RUNILSV2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RuniLSv2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RuniLSv2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Runirt///zzzzLSv2

% Last Modified by GUIDE v2.5 02-May-2011 14:40:22

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @RuniLSv2_OpeningFcn, ...
    'gui_OutputFcn',  @RuniLSv2_OutputFcn, ...
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


% --- Executes just before RuniLSv2 is made visible.
function RuniLSv2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RuniLSv2 (see VARARGIN)

% Choose default command line output for RuniLSv2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes RuniLSv2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);
handles.output = hObject;
% Set some FIXED parameters
handles.ITIValue = -1;
handles.NRepeats = 3;
handles.LoadLevels = [2 6];
handles.NumberListLength = 4;
handles.NoNumbersFlag = 0;
handles.FontSize = 60;

% Store these new values into the GUI data so they can be retrieved from
% elsewhere in the program
guidata(hObject,handles);
set(handles.subidText,'String','');
set(handles.Run1FBText,'String','');
set(handles.Run2NoFBText,'String','');
set(handles.Run3ScanText,'String','');
set(handles.Run3ScanText,'String','');


% --- Outputs from this function are returned to the command line.
function varargout = RuniLSv2_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in StartTrainRuns.
function StartTrainRuns_Callback(hObject, eventdata, handles)
% hObject    handle to StartTrainRuns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure wrtith handles and user data (see GUIDATA)

% Check to see if the subid field has been entered
if isempty(get(handles.subidText,'String'))
    set(handles.MessageBox,'String','Please enter subject ID');
else
    RuniLSv2('Run1FB_Callback',hObject,eventdata,guidata(hObject));
    if ~strcmp(get(handles.MessageBox,'String'),'Escape pressed, user exit');
        RuniLSv2('Run2FB_Callback',hObject,eventdata,guidata(hObject));
    end
end
%     % Turn on the button that will allow this run to be re done
%     set(handles.redoRun2,'Enable','active');
%     set(handles.redoRun2,'Visible','on');



% --- Executes on button press in StartScanRuns.
function StartScanRuns_Callback(hObject, eventdata, handles)
% hObject    handle to StartScanRuns (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RuniLSv2('Run4Scan_Callback',hObject,eventdata,guidata(hObject))
RuniLSv2('Run5Scan_Callback',hObject,eventdata,guidata(hObject))



% --- Executes on button press in Run1FB.
function Run1FB_Callback(hObject, eventdata, handles)
% hObject    handle to Run1FB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FIRST FEEDBACK RUN
PresentInstructionsFlag = 1;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 1;               % Present feedback? 1=yes, 0=no
ITI = 2;
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    set(handles.MessageBox,'String','');
    set(handles.Run1FBText,'String','');
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        PresentInstructionsFlag,FeedbackFlag,handles.NumberListLength,...
        handles.NRepeats,handles.NoNumbersFlag,handles.LoadLevels);
    set(handles.Run1FBText,'String',OutString);
    % if all goes well, report a summary of performance and update the push button
    set(handles.run1Success,'Value',1);
    
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end

% --- Executes on button press in Run2NoFB.
function Run2NoFB_Callback(hObject, eventdata, handles)
% hObject    handle to Run2NoFB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FIRST NO FEEDBACK RUN
PresentInstructionsFlag = 0;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 0;               % Present feedback? 1=yes, 0=no
ITI = 2;
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    set(handles.Run2NoFBText,'String','');
    set(handles.MessageBox,'String','');
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        PresentInstructionsFlag,FeedbackFlag,handles.NumberListLength,...
        handles.NRepeats,handles.NoNumbersFlag,handles.LoadLevels);
    set(handles.Run2NoFBText,'String',OutString);
    % if all goes well, report a summary of performance and update the push button
    set(handles.run2Success,'Value',1);
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end

% --- Executes on button press in Run3Scan.
function Run3Scan_Callback(hObject, eventdata, handles)
% hObject    handle to Run3Scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% FIRST SCANNER RUN
PresentInstructionsFlag = 0;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 0;               % Present feedback? 1=yes, 0=no
ITI = -1;
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    set(handles.Run3ScanText,'String','');
    set(handles.MessageBox,'String','');
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        PresentInstructionsFlag,FeedbackFlag,handles.NumberListLength,...
        handles.NRepeats,handles.NoNumbersFlag,handles.LoadLevels);
    set(handles.Run3ScanText,'String',OutString);
    % if all goes well, report a summary of performance and update the push button
    set(handles.run3Success,'Value',1);
catch me;
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.identifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end

% --- Executes on button press in Run4Scan.
function Run4Scan_Callback(hObject, eventdata, handles)
% hObject    handle to Run4Scan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% SECOND SCANNER RUN
PresentInstructionsFlag = 0;    % Present instructions? 1=yes, 0=no
FeedbackFlag = 0;               % Present feedback? 1=yes, 0=no
ITI = -1;
try
    % try to run the experiment
    subid = get(handles.subidText,'String');
    set(handles.Run4ScanText,'String','');
    set(handles.MessageBox,'String','');
    [ExperimentParameters OutString] = subfnLetterSternbergWithInterference(subid, handles.FontSize,ITI,...
        PresentInstructionsFlag,FeedbackFlag,handles.NumberListLength,...
        handles.NRepeats,handles.NoNumbersFlag,handles.LoadLevels);
    set(handles.Run4ScanText,'String',OutString);
    % if all goes well, report a summary of performance and update the push button
    set(handles.run4Success,'Value',1);
catch me
    if strcmp(me.message,'ESCAPE Pressed');
        set(handles.MessageBox,'String','Escape pressed, user exit');
    else
        ErrorString = ['Internal error: ' me.idetifier ' : ' me.message];
        set(handles.MessageBox,'String',ErrorString);
    end
    handles.output = me.message;
end

% --- Executes on button press in run1Success.
function run1Success_Callback(hObject, eventdata, handles)
% hObject    handle to run1Success (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run1Success


function Run1FBText_Callback(hObject, eventdata, handles)
% hObject    handle to Run1FBText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run1FBText as text
%        str2double(get(hObject,'String')) returns contents of Run1FBText as a double


% --- Executes during object creation, after setting all properties.
function Run1FBText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run1FBText (see GCBO)
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




function Run2NoFBText_Callback(hObject, eventdata, handles)
% hObject    handle to Run2FBText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run2FBText as text
%        str2double(get(hObject,'String')) returns contents of Run2FBText as a double


% --- Executes during object creation, after setting all properties.
function Run2NoFBText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run2FBText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

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

function Run3NoFBText_Callback(hObject, eventdata, handles)
% hObject    handle to Run2NoFBText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run2NoFBText as text
%        str2double(get(hObject,'String')) returns contents of Run2NoFBText as a double


% --- Executes during object creation, after setting all properties.
function Run3NoFBText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run2NoFBText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Run3ScanText_Callback(hObject, eventdata, handles)
% hObject    handle to Run3ScanText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run3ScanText as text
%        str2double(get(hObject,'String')) returns contents of Run3ScanText as a double


% --- Executes during object creation, after setting all properties.
function Run3ScanText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run3ScanText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Run4ScanText_Callback(hObject, eventdata, handles)
% hObject    handle to Run4ScanText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Run4ScanText as text
%        str2double(get(hObject,'String')) returns contents of Run4ScanText as a double


% --- Executes during object creation, after setting all properties.
function Run4ScanText_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Run4ScanText (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end




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


% --- Executes on button press in pushbutton13.
function pushbutton13_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton13 (see GCBO)
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
 


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3


% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
