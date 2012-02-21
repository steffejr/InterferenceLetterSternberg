function varargout = RunTempOrder(varargin)
% RUNTEMPORDER MATLAB code for RunTempOrder.fig
%      RUNTEMPORDER, by itself, creates a new RUNTEMPORDER or raises the existing
%      singleton*.
%
%      H = RUNTEMPORDER returns the handle to a new RUNTEMPORDER or the handle to
%      the existing singleton*.
%
%      RUNTEMPORDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in RUNTEMPORDER.M with the given input arguments.
%
%      RUNTEMPORDER('Property','Value',...) creates a new RUNTEMPORDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before RunTempOrder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to RunTempOrder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help RunTempOrder

% Last Modified by GUIDE v2.5 17-Jan-2012 13:50:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @RunTempOrder_OpeningFcn, ...
                   'gui_OutputFcn',  @RunTempOrder_OutputFcn, ...
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
 %End initialization code - DO NOT EDIT

% --- Executes just before RunTempOrder is made visible.
function RunTempOrder_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to RunTempOrder (see VARARGIN)

% Choose default command line output for RunTempOrder
handles.output = hObject;
handles.demog = varargin{1};
% Update handles structure
guidata(hObject, handles);


% --- Outputs from this function are returned to the command line.
function varargout = RunTempOrder_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function text1_Callback(hObject, eventdata, handles)
% hObject    handle to Title2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Title2 as text
%        str2double(get(hObject,'String')) returns contents of Title2 as a double


% --- Executes during object creation, after setting all properties.
function Title2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Title2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Run1.
function Run1_Callback(hObject, eventdata, handles)
% hObject    handle to Run1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RunType = 'BestAV'
handles.demog.Tag = 'BestAV';
[medRT propCor Trials] = TemporalOrderv3(RunType,handles.demog);
Str = sprintf('Median RT: %0.2f\n Prop. Correct: %0.2f\n',medRT,propCor);
set(handles.text1,'String',Str);
set(handles.button1,'value',1);



% --- Executes on button press in button1.
function button1_Callback(hObject, eventdata, handles)
% hObject    handle to button1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button1


% --- Executes on button press in Done.
function Done_Callback(hObject, eventdata, handles)
% hObject    handle to Done (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%ExitQuestion = questdlg('Are you sure you want to exit?','','Yes','No','No');
%if ~isempty(strmatch(ExitQuestion,'Yes'))
    close(RunTempOrder(1));
%end


function errors_Callback(hObject, eventdata, handles)
% hObject    handle to errors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of errors as text
%        str2double(get(hObject,'String')) returns contents of errors as a double


% --- Executes during object creation, after setting all properties.
function errors_CreateFcn(hObject, eventdata, handles)
% hObject    handle to errors (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function text2_Callback(hObject, eventdata, handles)
% hObject    handle to Title1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Title1 as text
%        str2double(get(hObject,'String')) returns contents of Title1 as a double


% --- Executes during object creation, after setting all properties.
function Title1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Title1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Run2.
function Run2_Callback(hObject, eventdata, handles)
% hObject    handle to Run2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RunType = 'BestVA'
handles.demog.Tag = 'BestVA';
[medRT propCor Trials] = TemporalOrderv3(RunType,handles.demog);
Str = sprintf('Median RT: %0.2f\n Prop. Correct: %0.2f\n',medRT,propCor);
set(handles.text2,'String',Str);
set(handles.button2,'value',1);


% --- Executes on button press in button2.
function button2_Callback(hObject, eventdata, handles)
% hObject    handle to button2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of button2


% --- Executes on button press in Instructions.
function Instructions_Callback(hObject, eventdata, handles)
% hObject    handle to Instructions (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
RunType = 'Instructions'
[medRT propCor Trials] = TemporalOrderv2(RunType);


% --- Executes during object creation, after setting all properties.
function text1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
