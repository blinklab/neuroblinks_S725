function varargout = pressTest_GUI(varargin)
% PRESSTEST_BARE MATLAB code for pressTest_bare.fig
%      PRESSTEST_BARE, by itself, creates a new PRESSTEST_BARE or raises the existing
%      singleton*.
%
%      H = PRESSTEST_BARE returns the handle to a new PRESSTEST_BARE or the handle to
%      the existing singleton*.
%
%      PRESSTEST_BARE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRESSTEST_BARE.M with the given input arguments.
%
%      PRESSTEST_BARE('Property','Value',...) creates a new PRESSTEST_BARE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before pressTest_bare_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to pressTest_bare_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help pressTest_bare

% Last Modified by GUIDE v2.5 05-Aug-2016 19:05:19

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @pressTest_bare_OpeningFcn, ...
                   'gui_OutputFcn',  @pressTest_bare_OutputFcn, ...
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


% --- Executes just before pressTest_bare is made visible.
function pressTest_bare_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to pressTest_bare (see VARARGIN)

% Choose default command line output for pressTest_bare
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% Set default values
setappdata(0,'puffdur',100)
setappdata(0,'numtrials',10)
setappdata(0,'ploteach',0)
setappdata(0,'filename','Filename.csv')
setappdata(0,'puffdata',[])

% UIWAIT makes pressTest_bare wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = pressTest_bare_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function PuffDurationTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to PuffDurationTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newpuffdur=str2double(get(hObject,'String'));
setappdata(0,'puffdur',newpuffdur);

% Hints: get(hObject,'String') returns contents of PuffDurationTextbox as text
%        str2double(get(hObject,'String')) returns contents of PuffDurationTextbox as a double


% --- Executes during object creation, after setting all properties.
function PuffDurationTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PuffDurationTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function NumTrialsTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to NumTrialsTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newnumtrials=str2double(get(hObject,'String'));
setappdata(0,'numtrials',newnumtrials);

% Hints: get(hObject,'String') returns contents of NumTrialsTextbox as text
%        str2double(get(hObject,'String')) returns contents of NumTrialsTextbox as a double


% --- Executes during object creation, after setting all properties.
function NumTrialsTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumTrialsTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in PlotEachCheckbox.
function PlotEachCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to PlotEachCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newploteach = get(hObject,'Value');
setappdata(0,'ploteach',newploteach)

% Hint: get(hObject,'Value') returns toggle state of PlotEachCheckbox



function FilenameTextbox_Callback(hObject, eventdata, handles)
% hObject    handle to FilenameTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

newfilename=get(hObject,'String');
setappdata(0,'filename',newfilename);

% Hints: get(hObject,'String') returns contents of FilenameTextbox as text
%        str2double(get(hObject,'String')) returns contents of FilenameTextbox as a double


% --- Executes during object creation, after setting all properties.
function FilenameTextbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to FilenameTextbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in RunButton.
function RunButton_Callback(hObject, eventdata, handles)
% hObject    handle to RunButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

tm=1:1:1000;
tm=tm';

if ispc
    arduino=serial('COM7','BaudRate',115200);
else
    arduino=serial('/dev/tty.usbmodem411','BaudRate',115200);
end

arduino.InputBufferSize=512*5;

stim_dur = getappdata(0,'puffdur');
fopen(arduino)
pause(1);
fwrite(arduino,2,'int8');
fwrite(arduino,stim_dur,'int16');
numtrials = getappdata(0,'numtrials');
puffdata = getappdata(0,'puffdata');
figure
hold on
for i = 1:numtrials
    pause(1);
    
    PMAX = 30;
    MAX_COUNT=2^14-1;
    
    % Transfer function for sensor is 10%-90% of full 14 bit counts
    % See datasheet
    out_max = MAX_COUNT * 0.9;
    out_min = MAX_COUNT * 0.1;
    
    % Tell Arduino to do a trial
    fwrite(arduino,1,'int8');
    
    
    pause(2);
    
    % Tell Arduino to get the data
    fwrite(arduino,3,'int8');
    pause(0.01)
    data=PMAX*(fread(arduino,1000,'uint16')-out_min)/(out_max-out_min);
    trialnums = ones(length(data),1)*i;
    stimdurs = ones(length(data),1)*stim_dur;
    
    addme = [trialnums,stimdurs,tm,data];
    puffdata = [puffdata;addme];
    
    plot(tm,data)
    
    clear data trialnums addme
    
end
fclose(arduino)

setappdata(0,'puffdata',puffdata)


% --- Executes on button press in SaveDataButton.
function SaveDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to SaveDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

saveme = getappdata(0,'puffdata');
filename = getappdata(0,'filename');
csvwrite(filename, saveme)


% --- Executes on button press in ClearDataButton.
function ClearDataButton_Callback(hObject, eventdata, handles)
% hObject    handle to ClearDataButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'puffdata',[])
