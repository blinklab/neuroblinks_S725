% Channel mappings
TRIGGER=8;

tm=1:1:1000;

if ispc
    arduino=serial('COM7','BaudRate',115200);
else
    arduino=serial('/dev/tty.usbmodem411','BaudRate',115200);
end

arduino.InputBufferSize=512*5;
fopen(arduino)

s=sprintf('Available commands:\n\n0: Quit\n1: Do trial\n2: Change stim duration\n\nCommand: ');
% s=sprintf('Available commands:\n\n0: Quit\n1: Do trial\n\nCommand: ');


while 1
    value = input(s);
    
    switch value
        case 0
            break
        case 1
            pressure=doPressureTrial(arduino,TRIGGER);
            figure
            plot(tm, pressure)
            fprintf('\nMax pressure: %2.1f\n', max(pressure))
        case 2
            stim_dur = input('Enter new stim duration: ');
            fwrite(arduino,2,'int8');
            fwrite(arduino,stim_dur,'int16');
    end
end

fclose(arduino)

