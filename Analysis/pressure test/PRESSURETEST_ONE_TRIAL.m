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

%% this section doesn't work now
% keepAsking=1;
% pufftimes=[];
% while keepAsking==1
%     if isempty(pufftimes)
%         temp=sprintf('Puff duration to test: ');
%         pufftimes=str2double(temp);
%         clear temp
%     else
%         temp=springf('Puff duration to test: ');
%         pufftimes(end+1)=str2double(temp);
%         clear temp
%     end
%     keepAsking=sprintf('Available commands:\n\n0: no more puff times\n1: more puff times\n\nCommand: ');
% end
% 
% repeats=sprintf('# repeats of each duration');
% repeats=str2double(repeats);

%% hard code variables
pufftimes=[10;12;15;18;20;22;25;30];
repeats=50;

puffstested=1;
pressure={};
while puffstested<=length(pufftimes)
    pufftotry=pufftimes(puffstested);
    for i=1:repeats
        fwrite(arduino,3,'int8');
        fwrite(arduino,pufftotry,'int8');
        pause(10)
        fwrite(arduino,1,'int8');
       
        % Get pressure data from Arduino
        % data = doPressureTrial(arduino,channel)
        
        PMAX = 30;
        MAX_COUNT=2^14-1;
        
        % Transfer function for sensor is 10%-90% of full 14 bit counts
        % See datasheet
        out_max = MAX_COUNT * 0.9;
        out_min = MAX_COUNT * 0.1;
        
%         channel=TRIGGER;
%         % Tell Arduino to do a trial
%         switch channel  % Do switch so we can add more conditions if needed
%             case 8
%                 fwrite(arduino,1,'int8');
%         end
        
        pause(2);
        
        % Tell Arduino to get the data
        fwrite(arduino,2,'int8');
        pause(0.01)
        if isempty(pressure)
            pressure{1,1}=PMAX*(fread(arduino,1000,'uint16')-out_min)/(out_max-out_min);
            pressure{1,2}=pufftotry;
        else
            pressure{end+1,1}=PMAX*(fread(arduino,1000,'uint16')-out_min)/(out_max-out_min);
            pressure{end,2}=pufftotry;
        end
                    
    end
    
    puffstested=puffstested+1;
    
    pause(10)
end

fclose(arduino)

%% make plots & save data
% starthere=1;
% figure
% for i=1:length(pufftimes)
%     subplot(1,8,i)
%     averageme=[];
%     for j=starthere:starthere+49
%         if j>1 % exclude first trial because I can't figure out how to use the arduino quite right
%             hold on
%             plot(pressure{j,1})
%         end
%     end
%     xlim([0,200])
%     ylim([0, 10])
%     title([num2str(pufftimes(i)), ' ms'])
%     starthere=starthere+50;
% end
cd('C:\greg\matlab\pressure test')
starthere=1;
figure
cc=hsv(8);
for i=1:length(pufftimes)
    averageme=[];
    for j=starthere:starthere+49
        if j>1 % exclude first trial because I can't figure out how to use the arduino quite right
            averageme(1:1000, j-starthere+1)=pressure{j,1};
        end
    end
    if starthere==1
        averageme=averageme(:,2:end);
    end
    filename=strcat('rig2_',num2str(pufftimes(i)),'ms_pressures.csv');
    csvwrite(filename,averageme);
    plotme=[];
    [rows cols]=size(averageme);
    for r=1:rows
        plotme(r,1)=mean(averageme(r,:));
        plotme(r,2)=std(averageme(r,:))/sqrt(cols);
    end
    hold on
    a=plot([1:1000], plotme(:,1), 'color', cc(i,:));
    starthere=starthere+50;
    [peakPressure(i), peakTime(i)]=max(plotme(:,1));
    differences=diff(plotme(:,1));
    idx=find(abs(differences)>0.001);
    puffBegin(i)=idx(1,1)+1;
    differences2=diff(idx);
    idx2=find(differences2>1);
    puffEnd(i)=idx(idx2(1));
end
xlim([0, 120])
ylim([0,10])
legend('10ms', '12ms', '15ms', '18ms', '20ms', '22ms', '25ms', '30ms', 'Location', 'EastOutside')
print('-dtiff', '-r300', 'rig2_pressurePlot')
close all

subplot(3,2,[1])
scatter(pufftimes, peakPressure)
ylabel('Peak Pressure (psi)')
xlim([7 33])
subplot(3,2,[2])
scatter(pufftimes, peakTime)
ylabel('Peak Time (ms)')
xlim([7 33])
subplot(3,2,[3])
scatter(pufftimes, puffBegin)
ylabel('Puff Onset (ms)')
xlim([7 33])
subplot(3,2,[4])
scatter(pufftimes, puffEnd)
ylabel('Puff Offset (ms)')
xlabel('Programmed Puff Duration (ms)')
xlim([7 33])
subplot(3,2,[5])
scatter(pufftimes, puffEnd-puffBegin)
ylabel('Puff Duration (ms)')
xlabel('Programmed Puff Duration (ms)')
xlim([7 33])
print('-dtiff', '-r300', 'rig2_statsplot')

% columnHeaders={'Programmed Duration', 'Peak Pressure', ...
%     'Peak Time', 'Puff Onset', 'Puff Offset'};
array=[pufftimes,peakPressure',peakTime',puffBegin',puffEnd'];
% saveme=num2cell(array);
% saveme=[columnHeaders;saveme];
%csvwrite('rig2_pressurestats.csv', saveme)
csvwrite('rig2_pressurestats.csv', array)
