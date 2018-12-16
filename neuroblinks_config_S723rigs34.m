% Configuration settings that might be different for different users/computers
% Should be somewhere in path but not "neuroblinks" directory or subdirectory

% Rig specific settings
ALLOWEDDEVICES = {'arduino','tdt'};
DEFAULTRIG=1;

%% modification by OK on 9/10/15 to try changing rig 3 camera to solve dropped frames problem
%ALLOWEDCAMS = {'02-2020C-07418','02-2020C-07421'};
ALLOWEDCAMS = {'02-2020C-07320','02-2020C-07421'};
DEFAULTDEVICE = 'arduino';
%% END MODIFICATION

ARDUINO_IDS = {'FFFFFFFFFFFF513B2506','75330303035351B061B2'}; % temp test
%ARDUINO_IDS = {'FFFFFFFFFFFF513B2506','75439333235351214051'};
% ARDUINO_IDS = {'8&140042BF&0&0000','75330303035351B061B2'};
% COM15 - Arduino Srl (www.arduino.org) - USB\VID_2A03&PID_003D\7&1F0EA464&0&3
% COM14 - Arduino LLC (www.arduino.cc) - USB\VID_2341&PID_003D\7&1F0EA464&0&2

% COM2 - Arduino Srl (www.arduino.org) - USB\VID_2A03&PID_003D\FFFFFFFFFFFF513B2506
% COM5 - Arduino LLC (www.arduino.cc) - USB\VID_2341&PID_003D\75330303035351B061B2

% NOTE: In the future this should be dynamically set based on pre and post time
metadata.cam.recdurA=1000;

% --- camera settings ----
metadata.cam.init_ExposureTime=4900;


% TDT tank -- not necessary for Arduino version
tank='optoelectrophys'; % The tank should be registered using TankMon (really only matters for TDT version)

% GUI
% -- specify the location of bottomleft corner of MainWindow & AnalysisWindow  --
ghandles.pos_mainwin=[5,50];     ghandles.size_mainwin=[840 600]; 
ghandles.pos_anawin= [570 45];    ghandles.size_anawin=[1030 840]; 
ghandles.pos_oneanawin=[5 45];    ghandles.size_oneanawin=[560 380];   
ghandles.pos_lfpwin= [570 45];    ghandles.size_lfpwin=[600 380];