tm=1:1:1000;

if ispc
    arduino=serial('COM7','BaudRate',115200);
else
    arduino=serial('/dev/tty.usbmodem411','BaudRate',115200);
end

arduino.InputBufferSize=512*5;
fopen(arduino)

stim_dur = 300;

pause(1);

fwrite(arduino,2,'int8');
fwrite(arduino,stim_dur,'int16');

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

fclose(arduino)

plot(tm,data)
