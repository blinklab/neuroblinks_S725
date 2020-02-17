function savetrial()
% Load objects from root app data
vidobj=getappdata(0,'vidobj');

% 4096 counts = 1 revolution = 15.24*pi cm for 6 inch diameter cylinder
counts2cm = @(count) double(count) ./ 4096 .* 15.24 .* pi; 

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


% Get encoder data from Arduino
if isappdata(0,'arduino')  && saveEncData == 1
  arduino = getappdata(0,'arduino');
  
  campretime = metadata.cam.time(1);
  camposttime = sum(metadata.cam.time(2:3));
  binsToExpect = (campretime + camposttime) / 5; % assumes 5 ms bins

  if arduino.BytesAvailable > 0
    fread(arduino, arduino.BytesAvailable); % Clear input buffer
  end

  fwrite(arduino,2,'uint8');  % Tell Arduino we're ready for it to send the data

  data_header=(fread(arduino,1,'uint8'));
 % disp(data_header)
  if data_header == 100
     % disp('GOT HERE')
    encoder.counts=(fread(arduino,binsToExpect,'int32'));
    %encoder.counts=(fread(arduino,sum(metadata.cam.time)/5,'int32'));
    encoder.displacement=counts2cm(encoder.counts-encoder.counts(1));
  end

  time_header=(fread(arduino,1,'uint8'));
  %disp(time_header)
  if time_header == 101
      %disp('GOT Here 101')
     encoder.time=(fread(arduino,binsToExpect,'uint32'));
%          encoder.time=(fread(arduino,sum(metadata.cam.time)/5,'uint32'));
    encoder.time=encoder.time-encoder.time(1);
  end

else
    encoder = [];
end

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
