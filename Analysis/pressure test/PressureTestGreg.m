function varargout = PressureTestGreg(varargin)
% PRESSURETESTGREG MATLAB code for PressureTestGreg.fig
%      PRESSURETESTGREG, by itself, creates a new PRESSURETESTGREG or raises the existing
%      singleton*.
%
%      H = PRESSURETESTGREG returns the handle to a new PRESSURETESTGREG or the handle to
%      the existing singleton*.
%
%      PRESSURETESTGREG('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PRESSURETESTGREG.M with the given input arguments.
%
%      PRESSURETESTGREG('Property','Value',...) creates a new PRESSURETESTGREG or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before PressureTestGreg_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to PressureTestGreg_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help PressureTestGreg

% Last Modified by GUIDE v2.5 11-Aug-2016 10:16:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @PressureTestGreg_OpeningFcn, ...
                   'gui_OutputFcn',  @PressureTestGreg_OutputFcn, ...
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


% --- Executes just before PressureTestGreg is made visible.
function PressureTestGreg_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to PressureTestGreg (see VARARGIN)

% Choose default command line output for PressureTestGreg
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

%Set Defaults
setappdata(0,'puffdur',300)
setappdata(0,'numtrials',10)
setappdata(0,'ploteach',0)
setappdata(0,'filename','PressureTestData.csv')
setappdata(0,'fname','PressureTestData.csv')
setappdata(0,'puffdata',[])
% UIWAIT makes PressureTestGreg wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = PressureTestGreg_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

function PuffDurationBox_Callback(hObject, eventdata, handles)
% hObject    handle to PuffDurationBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newpuffdur=str2double(get(hObject,'String'));
setappdata(0,'puffdur',newpuffdur);

% Hints: get(hObject,'String') returns contents of PuffDurationBox as text
%        str2double(get(hObject,'String')) returns contents of PuffDurationBox as a double


% --- Executes during object creation, after setting all properties.
function PuffDurationBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to PuffDurationBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function NumberofTrialsBox_Callback(hObject, eventdata, handles)
% hObject    handle to NumberofTrialsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newnumtrials=str2double(get(hObject,'String'));
setappdata(0,'numtrials',newnumtrials);
% Hints: get(hObject,'String') returns contents of NumberofTrialsBox as text
%        str2double(get(hObject,'String')) returns contents of NumberofTrialsBox as a double


% --- Executes during object creation, after setting all properties.
function NumberofTrialsBox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to NumberofTrialsBox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in PlotEach.
function PlotEach_Callback(hObject, eventdata, handles)
% hObject    handle to PlotEach (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
newploteach = get(hObject,'Value');
setappdata(0,'ploteach',newploteach)



% --- Executes on button press in ClearData.
function ClearData_Callback(hObject, eventdata, handles)
% hObject    handle to ClearData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
setappdata(0,'puffdata',[])

% --- Executes on button press in RunTest.
function RunTest_Callback(hObject, eventdata, handles)
% hObject    handle to RunTest (see GCBO)
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
% Hint: get(hObject,'Value') returns toggle state of RunTest


% --- Executes on button press in Savedatabutton.
function Savedatabutton_Callback(hObject, eventdata, handles)
% hObject    handle to Savedatabutton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
saveme = getappdata(0,'puffdata');
filename = getappdata(0,'filename');
csvwrite(filename, saveme)



function Fname_Callback(hObject, eventdata, handles)
% hObject    handle to Fname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Fname as text
%        str2double(get(hObject,'String')) returns contents of Fname as a double
newfilename=get(hObject,'String');
setappdata(0,'filename',newfilename);

% --- Executes during object creation, after setting all properties.
function Fname_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Fname (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
