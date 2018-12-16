%%
clear all
subjectlist=['GW073';];

Type=1; %%% 1:process date offsets specified for all subjects 2: process datestrings inputted for specific subjects; 3: process ALL folders;

%Type 1 Inputs: Horizontal vector of date offsets
if Type==1
    offsets=[10];
end

%Type 2 Inputs: Vertical vectors of date strings. Each animal corresponds
%to the order in the subjectlist
if Type==2
    Animal1=['170823';'170825';'170830';'170907';'170908';'170911';'170912';'170913';];
    Animal2=['170621';'170622'];
    Animal3=['170621'];
    Animal4=['170621'];
    days=cell(4,max([length(Animal1(:,1)) length(Animal2(:,1)) length(Animal3(:,1)) length(Animal4(:,1))]));
    for i=1:4 %%Puts all of the date strings into the cell 'days' created above.
        if i==1
            for j=1:length(Animal1(:,1))
                days{i,j}=Animal1(j,:);
            end
        elseif i==2
            for j=1:length(Animal2(:,1))
                days{i,j}=Animal2(j,:);
            end
        elseif i==3
            for j=1:length(Animal3(:,1))
                days{i,j}=Animal3(j,:);
            end
        elseif i==4
            for j=1:length(Animal4(:,1))
                days{i,j}=Animal4(j,:);
            end
        end
    end
end

%Type 3 Input: None required, it will automatically load all folders for a
%given animal. CD must be the folder containing all subjects

%%%%%%%%%%%%%%%%%%%% Main Loop%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

for i=1:length(subjectlist(:,1)) %%Loops for each subject
    if Type==1 %1:process date offsets specified
        DaysToProcess=cell(length(offsets),1);
        for j=1:length(offsets)
            DaysToProcess{j}=offsets(j);
        end
    elseif Type==2 %2: process datestrings specified
        for j=1:length(days(i,:))
            if isempty(days{i,j})==0
                DaysToProcess{j}=days{i,j};
            end
        end
    elseif Type==3 %3: process ALL folders
        d=dir(subjectlist(i,:));
        d=d(3:end); % get rid of '.' and '..'
        d=d([d.isdir]); % only list directories
        ALLfolders = getFullFileNames(subjectlist(i,:),d);
        DaysToProcess=ALLfolders;
    end
    
    for j=1:length(DaysToProcess) %%Loops for each day
        user = 'Wojo';
        mouse = subjectlist(i,:);
        session = 1;
        us1 = 3;
        cs1 = 7;
        
        if Type==1
            day_offset=DaysToProcess{j};
            day = datestr(now-day_offset,'yymmdd');
            folder = fullfile('\\bcmcloudbk\bcm-neuro-blinklab',user, mouse, day);
        elseif Type==2
            day=DaysToProcess{j};
            folder=fullfile('\\bcmcloudbk\bcm-neuro-blinklab',user, mouse,day);
        elseif Type==3
            temp=DaysToProcess{j};
            day=temp(7:end);
            folder=fullfile('\\bcmcloudbk\bcm-neuro-blinklab',user, mouse,day);
        end
   
    
        
        
        %%%%%%%%%%%%%%%%%%%%%%%Process Single Day%%%%%%%%%%%%%%%%%%%%%%%%%%

        if exist(fullfile(folder,'compressed',sprintf('%s_%s_t01_calib.mp4',mouse,day))) %%%is it a recording day? (t01)
            trials = processTrialsSeq(fullfile(folder,'compressed'),...
                fullfile(folder,'compressed',sprintf('%s_%s_t01_calib.mp4',mouse,day)));
        elseif exist(fullfile(folder,'compressed',sprintf('%s_%s_s01_calib.mp4',mouse,day))) %%is it a behavioral day? (s01)
            trials = processTrialsSeq(fullfile(folder,'compressed'),...
                fullfile(folder,'compressed',sprintf('%s_%s_s01_calib.mp4',mouse,day)));
            %%if its an electrical stimulation day (e01) then it skips over it.
        end
        
        save(fullfile(folder,'trialdata.mat'),'trials');
        
        %%%%%%%%%%%%%%%%%%%%%%%%Make Plots%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        [hf1,hf2,hf3,hf4,hf5,hf6,hf7,hf8]=makePlotsSeq(trials);
        
        %save .fig files
        hgsave(hf1,fullfile(folder,'CRs_Paired_Trials.fig'));
        hgsave(hf2,fullfile(folder,'CR_amp_trend_Paired Trials.fig'));
        hgsave(hf3,fullfile(folder,'ITI.fig'));
        hgsave(hf4,fullfile(folder,'CS_CRs.fig'));
        hgsave(hf5,fullfile(folder,'CS_CR_amp_trend.fig'));
        hgsave(hf6,fullfile(folder,'Pos_v_Vel_All.fig'));
        hgsave(hf7,fullfile(folder,'Pos_v_Vel_CSONLY.fig'));
        hgsave(hf8,fullfile(folder,'Separated_ISIs.fig'));
        
        %save pdf versions of the figures
        print(hf1,fullfile(folder,sprintf('%s_%s_CRs_Paired_Trials.pdf',mouse,day)),'-dpdf')
        print(hf2,fullfile(folder,sprintf('%s_%s_CR_amp_trend_Paired_Trials.pdf',mouse,day)),'-dpdf')
        print(hf3,fullfile(folder,sprintf('%s_%s_Actual_ITIs.pdf',mouse,day)),'-dpdf')
        print(hf4,fullfile(folder,sprintf('%s_%s_CS_only_CRs.pdf',mouse,day)),'-dpdf')
        print(hf5,fullfile(folder,sprintf('%s_%s_CS_only_CR_amp_trend.pdf',mouse,day)),'-dpdf')
        print(hf6,fullfile(folder,sprintf('%s_%s_Pos_v_Vel_All.pdf',mouse,day)),'-dpdf')
        print(hf7,fullfile(folder,sprintf('%s_%s_Pos_v_Vel_CSONLY.pdf',mouse,day)),'-dpdf')
        print(hf8,fullfile(folder,sprintf('%s_%s_Separated_ISIs.pdf',mouse,day)),'-dpdf')
        close all
    end
end

    
  
    
