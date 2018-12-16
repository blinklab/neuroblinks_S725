function data=doPressureTrial(arduino,channel)
% Get pressure data from Arduino
% data = doPressureTrial(arduino,channel)

PMAX = 30;
MAX_COUNT=2^14-1;

% Transfer function for sensor is 10%-90% of full 14 bit counts
% See datasheet
out_max = MAX_COUNT * 0.9;
out_min = MAX_COUNT * 0.1;

% Tell Arduino to do a trial
switch channel  % Do switch so we can add more conditions if needed
    case 8
        fwrite(arduino,1,'int8');
end 

pause(2);

% Tell Arduino to get the data
fwrite(arduino,3,'int8');
pause(0.01)
data=PMAX*(fread(arduino,1000,'uint16')-out_min)/(out_max-out_min);
% data=PMAX*(ReadData(arduino)-out_min)/(out_max-out_min);
% data=ReadData(arduino);
% data=fread(arduino,1000,'uint16');
