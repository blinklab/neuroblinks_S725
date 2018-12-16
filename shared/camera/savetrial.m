function savetrial()
% Load objects from root app data
vidobj=getappdata(0,'vidobj');

pause(1e-3)
% data=getdata(vidobj,vidobj.TriggerRepeat+1);
data=getdata(vidobj,vidobj.FramesPerTrigger*(vidobj.TriggerRepeat + 1));
% videoname=sprintf('%s\\%s_%s_%03d',metadata.folder,metadata.mouse,datestr(now,'yy-mm-dd'),metadata.trialnum);
pause(1e-3)

online_bhvana(data);
metadata=getappdata(0,'metadata');

pause(1e-3)
setappdata(0,'lastdata',data);
setappdata(0,'lastmetadata',metadata);

% % Get encoder data from Arduino
% if isappdata(0,'arduino')
%   arduino = getappdata(0,'arduino');
%
%   if arduino.BytesAvailable > 0
%     fread(arduino, arduino.BytesAvailable); % Clear input buffer
%   end
%
%   fwrite(arduino,2,'uint8');  % Tell Arduino we're ready for it to send the data
%
%   data_header=(fread(arduino,1,'uint8'));
%   if data_header == 100
%     encoder.counts=(fread(arduino,200,'int32'));
%   end
%
%   time_header=(fread(arduino,1,'uint8'));
%   if time_header == 101
%     encoder.time=(fread(arduino,200,'uint32'));
%   end
%
% end
encoder = [];

% --- saved in HDD ---
trials=getappdata(0,'trials');
t0=clock;

videoname=sprintf('%s\\%s_%03d',metadata.folder,metadata.TDTblockname,metadata.cam.trialnum);
if trials.savematadata
    save(videoname,'metadata')
elseif exist('encoder','var')
    save(videoname,'data','metadata','encoder','-v6')
else
    save(videoname,'data','metadata','-v6')
end

fprintf('Data from trial %03d successfully written to disk.\n',metadata.cam.trialnum)


% --- trial counter updated and saved in memory ---
metadata.cam.trialnum=metadata.cam.trialnum+1;
if strcmpi(metadata.stim.type,'conditioning') | strcmpi(metadata.stim.type,'electrocondition')
    metadata.eye.trialnum1=metadata.eye.trialnum1+1;
end
metadata.eye.trialnum2=metadata.eye.trialnum2+1;
setappdata(0,'metadata',metadata);

pause(1)

%
% % --- online spike saving, executed by timer ---
% etime1=round(1000*etime(clock,t0))/1000;
% tm1 = timer('TimerFcn',@online_savespk_to_memory, 'startdelay', max(0, 4-etime1));
% start(tm1);
%
