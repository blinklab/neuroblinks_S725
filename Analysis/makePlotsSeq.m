function varargout = makePlotsSeq(trials)

us = mode(trials.c_usnum);
cs = mode(trials.c_csnum);
period=mode(trials.c_csperiod)/5; %%frames

%% Paired Trials Eyelid traces
hf1=figure;
hax=axes;
idx = find(trials.c_isi<1000 & trials.c_usdur>0);
io1= find(trials.c_isi>1000 & trials.c_usdur>0 & ismember(trials.session_of_day, 1));
io2= find(trials.c_isi>1000 & trials.c_usdur>0 & ismember(trials.session_of_day, 2));
if isempty(io2)
    idxom =io1;
else
    idxom=[io1; io2];
end

if isempty(idxom)
    set(hax,'ColorOrder',jet(length(idx)),'NextPlot','ReplaceChildren');
    plot(trials.tm(1,:),trials.eyelidpos(idx,:))
    hold on
    plot(trials.tm(1,:),mean(trials.eyelidpos(idx,:)),'k','LineWidth',2)
    hold on
    CSx=[0 0.230 0.230 0]*1.0125;
    CSy=[-0.1 -0.1 -0.05 -0.05];
    patch(CSx,CSy,'g')
    hold on
    plot([0.200 0.200],[-0.1 1.1],':k')
    hold on
    axis([trials.tm(1,1) trials.tm(1,end) -0.1 1.1])
    title('CS-US')
    xlabel('Time from CS (s)')
    ylabel('Eyelid pos (FEC)')
else
    win=[];
    for i=1:length(idxom)
        w= floor(((tm2frm((trials.c_isi(idxom(i))-500)/1e3))*1.0125)):1:floor(((tm2frm((trials.c_isi(idxom(i))+300)/1e3)*1.0125)));%%800ms window around US presentation
        if (i>1 && length(w)>length(win))
            win(i,:)=w(1:length(win));%%with the frame correction some windows are 1-2 frames longer, this truncates longer ones
        else
            win(i,:)=w;
        end
    end
    puff=141.75;%%%141.75 (140*1.0125) is 700ms into the window (US presentation)
    pos=[];
    for i=1:length(idxom)
        pos(i,:)=trials.eyelidpos(idxom(i),win(i,:));
    end
    
    if isempty(idxom)==0
        set(hax,'ColorOrder',jet(length(idxom)),'NextPlot','ReplaceChildren');
        plot(1:size(win,2),pos)
        hold on
        mpos=NaN(size(win,2));
        for i=1:size(pos,2)
            mpos(i)=mean(pos(:,i));
        end
        
        plot(1:size(win,2),mpos,'k','LineWidth',2)
        
        gr = [0.9 0.9 0.9];%color code for gray
        xGo = [puff-(235/5) puff-(200/5) puff-(200/5) puff-(235/5)]; %%go signal 35ms long that begins 235ms before the US
        x1 = xGo-period; %%last flash before the omitted flash
        x2 = x1-period; %%second to last flash
        x3 = x2-period; %%third to last flash
        gap=(trials.c_isi(1)-floor(trials.c_isi(1)/trials.c_csperiod(1))*trials.c_csperiod(1))/5;%%calculates the gap between light off and puff onset
        cslong = [0 puff-(40+period) puff-(40+period) 0]; %% plots continuous light for offset animals
        y= [-0.1 -0.1 0 0];%y axes for all charts
        
        if mode(trials.c_csdur)==mode(trials.c_csperiod)%%decides whether to plot offset patches or omission patches
            patch(cslong,y,gr)
            plot([puff puff],[-0.1 1.1],':k')
        else
            patch(x1,y,gr)
            patch(x2,y,gr)
            patch(x3,y,gr)
            patch(xGo,y,'g')
            plot([puff puff],[-0.1 1.1],':k')%%%141.75 is 700ms into the window (US presentation)
        end
        
        axis([1 size(win,2) -0.1 1.1])
        title('Paired Trials Eyelid Traces')
        xlabel('Time from US Onset (ms)')
        ylabel('Eyelid pos (FEC)')
        ticks=0:20:160;
        set(gca,'XTick',ticks*1.0125)
        set(gca,'XTickLabel',-700:100:100)
    end
end



%% Paired CR amplitudes
hf2=figure;
pre = 1:tm2frm(0.1);
idx = find(trials.c_usdur>0 & trials.c_usnum==us & trials.c_isi<1000);
io1= find(trials.c_isi>1000 & trials.c_usdur>0 & ismember(trials.session_of_day, 1));
io2= find(trials.c_isi>1000 & trials.c_usdur>0 & ismember(trials.session_of_day, 2));
if isempty(io2)
    idxom =io1;
else
    idxom=[io1; io2];
end

if isempty(idxom)
    win = tm2frm(0.2+trials.c_isi/1e3):tm2frm(0.2+trials.c_isi/1e3+0.015)*1.0125;
    CRamp=zeros(1,length(idx));
    for i=1:length(idx)
        CRamp(i) = max(trials.eyelidpos(idx(i),win)) - mean(trials.eyelidpos(idx(i),pre),2);
    end
    plot(1:length(idx),CRamp,'r.')
    hold on
    plot([1 length(idx)],[0.1 0.1],':k')
    axis([1 length(idx) -0.1 1.1])
    title('CS-US')
    xlabel('Trials')
    ylabel('CR size')
else
    win=NaN(length(idxom),4);%generates frame # windows for analysis of CR size at the end of the isi plus a few frames to allow for US delivery delay
    for i=1:length(idxom)
        win(i,:)= round((tm2frm(0.2+trials.c_isi(idxom(i))/1e3):tm2frm(0.2+trials.c_isi(idxom(i))/1e3+0.015))*1.0125);
    end
    
    CRamp=zeros(1,length(idxom)); %calculates size of CR by subtracting mean of eyelid closure at the start of the trial from eyelid clsoure during CR window
    for i=1:length(idxom)
        CRamp(i) = max(trials.eyelidpos(idxom(i),win(i,:))) - mean(trials.eyelidpos(idxom(i),pre),2);
    end
    
    %False Starts
    FS=zeros(1,length(idxom));
    Vel=zeros(length(idxom),length(trials.tm(1,:))); %%calculates velocities for every frame in every trial
    for j=1:length(idxom)
        for k=1:(length(trials.tm(j,:))-1)
            Vel(j,(k+1))=( (trials.eyelidpos(idxom(j),k+1)-trials.eyelidpos(idxom(j),k)) / ( trials.tm(idxom(j),(k+1))- trials.tm(idxom(j),k) ) );
        end
    end
    threshold=2;
    duration=5;
    maxslope=100;
    probs=NaN(length(idxom),length(trials.tm(idxom(1),:))); %%stores a 1 or 0 for each frame. 1 if velocity > threshold 0 if velocity < threshold. 1200 allows for it to process both 135 and 300ms periods
    for j=1:length(idxom) %%For every trial
        for k=41:(length(1:floor(tm2frm(0.2+trials.c_isi(idxom(j))/1e3)*1.0125)))
            if ( ( mean(Vel(find(idxom==idxom(j)),k:(k+duration-1)),2)>threshold || mean(Vel(find(idxom==idxom(j)),(k-(duration-1)):k),2)>threshold )&& (Vel(find(idxom==idxom(j)),k)<maxslope) )%%if velocity is greater than threshold for that frame, then record 1, else 0.
                probs(j,k)=1;
            else
                probs(j,k)=0;
            end
        end
    end
    seq=0;
    start=NaN;
    counter=0;
    for j=1:size(probs,1)
        for k=1:size(probs,2)-9
            if seq==0 %%if not within a sequence already
                if ( mean(probs(j,k:(k+3)))==1 ) %% if the next three frames pass the algorithm
                    start=k; %%denote starting frame of false start
                    seq=1;
                end
            elseif seq==1
                if ismember(1,probs(j,k:(k+9)))==0
                    %denote start of false start in single1
                    seq=0;
                    counter=counter+1;
                end
            end
        end
        FS(j)=counter;
        counter=0;
    end
    x=1:length(idxom);
    [CRFS, h1, h2] = plotyy(x,CRamp,x,FS);
    hold on
    plot([1 length(trials.trialnum)],[0.1 0.1],':k')
    %plot([51 150],[0.1 0.1],':k')
    axis([1 length(trials.trialnum) -0.1 1.1])
    %axis([51 150 -0.1 1.1])
    set(h1(1),'color','b','marker','.','MarkerSize',12,'linestyle','none');
    set(h2(1),'color','c','marker','.','MarkerSize',7,'linestyle','none');
    axis(CRFS(2),[1 length(x) 0 10])
    set(CRFS(2),'Ytick',0:1:10)
    set(CRFS(1),'Ytick',-0.1:0.2:1.1)
    ylabel(CRFS(1),'CR amplitude') % left y-axis
    ylabel(CRFS(2),'Number of False Starts') % right y-axis
    title('Paired Trials CR amiplitudes and Number of False Starts')
    xlabel('Trial Number')
end

%% ITIs

hf3=figure;
scatter(1:length(trials.ITIs),trials.ITIs,15,'filled','r');
%scatter([51:150],trials.ITIs,15,'filled','r');
hold on
axis([0 length(trials.ITIs)+1 0 max(trials.ITIs)+1]);
%axis([51 150 0 max(trials.ITIs)+1])
title('ITIs')
xlabel('ITI number')
ylabel('Duration (seconds)')

%% CS Only Eyelid traces
hf4=figure;
hax=axes;

idx = find(trials.c_usdur==0 & trials.c_usnum==us & trials.c_csnum==cs);

if isempty(idx)==0
    set(hax,'ColorOrder',jet(length(idx)),'NextPlot','ReplaceChildren');
    plot(trials.tm(3,:),trials.eyelidpos(idx,:))
    hold on 
    plot(trials.tm(3,:),mean(trials.eyelidpos(idx,:)),'k','LineWidth',2)
    axis([trials.tm(3,1) trials.tm(2,end) -0.1 1.1])
    title('CS Only')
    xlabel('Time from CS (s)')
    ylabel('Eyelid pos (FEC)')
   
end

%% CS only CR amplitudes
hf5=figure;
idx = find(trials.c_usdur==0 & trials.c_usnum==us & trials.c_csnum==cs);

if isempty(idx)==0
    pre = 1:tm2frm(0.1);
    for i=1:length(idx)
        win(i,:)= tm2frm(0.2+isi(idx(i))/1e3):tm2frm(0.2+isi(idx(i))/1e3+0.015);
    end
    CRamp=[]; %calculates size of CR by subtracting mean of eyelid closure at the start of the trial from eyelid clsoure during CR window
    for i=1:length(idx)
        CRamp(i) = mean(trials.eyelidpos(idx(i),win(i,:)),2) - mean(trials.eyelidpos(idx(i),pre),2);
    end
    scatter(trials.trialnum(idx),CRamp,15,'filled','b')
    hold on
    plot([1 length(trials.trialnum)],[0.1 0.1],':k')
    %plot([51 150],[0.1 0.1],':k')
    axis([1 length(trials.trialnum) -0.1 1.1])
    %axis([51 150 -0.1 1.1])
    title('CS Only')
    xlabel('Trials')
    ylabel('CR size')
end

%% Mean Velocity and Position Graph Paired Trials

hf6=figure;
idx= find(trials.c_isi<1000 & trials.c_usdur>0);
idxom = find(trials.c_isi>1000 & trials.c_usdur>0);

if isempty(idxom)==0
    win=[];
    for i=1:length(idxom)
        win(i,:)=floor(((tm2frm((trials.c_isi(idxom(i))-500)/1e3))*1.0125)):1:floor(((tm2frm((trials.c_isi(idxom(i))+300)/1e3)*1.0125)));
    end
    pos=[];
    for i=1:length(idxom)
        pos(i,:)=trials.eyelidpos(idxom(i),win(i,:));
    end
    VPx=([1:size(win,2)])/200;
    Position=NaN(size(win,2));
    for i=1:size(pos,2)
        Position(i)=mean(pos(:,i));
    end
    Vel=[0];
    
    for i=1:length(Position)-1
        Vel(i+1)=(Position(i+1)-Position(i))/(VPx(i+1)-VPx(i));
    end
    [PV, h1, h2] = plotyy(VPx,Position,VPx,Vel);
    
    title('Position vs. Velocity Paired Trials')
    xlabel('Time')
    set(PV(1),'YLim',[-0.1 1.1])
    set(PV,'XLim',[0 max(VPx)])
    set(PV(2),'YLim',[-10 40])
    set(h1,'Color','b')
    set(h2,'Color','r')
    set(PV(1),'YTick',[-0.1:0.2:1.1])
    set(PV(2),'YTick',[-10:10:40])
    ylabel(PV(1),'Position') % left y-axis
    ylabel(PV(2),'Velocity') % right y-axis
end


%% Mean Velocity and Position Graph CS only 

hf7=figure;
idx = find(trials.c_isi>1000 & trials.c_usdur==0 & trials.c_usnum==us & trials.c_csnum==cs);

if isempty(idx)==0
    win=[];
    for i=1:length(idx)
        win(i,:)= (tm2frm((isi(idx(i))-500)/1e3):(tm2frm((isi(idx(i))+500)/1e3)));
    end
    pos=[];
    for i=1:length(idx)
        pos(:,i)=trials.eyelidpos(idx(i),win(i,:));
    end
    VPx=([1:length(win)])/200;
    Position=[];
    for i=1:length(pos)
       Position(i,:)=mean(pos(i,:));
    end
    Vel=[0];
    
    for i=1:length(Position)-1
        Vel(i+1)=(Position(i+1)-Position(i))/(VPx(i+1)-VPx(i));
    end
    [PV, h1, h2] = plotyy(VPx,Position,VPx,Vel);
    title('Position vs. Velocity Paired Trials')
    xlabel('Time')
    set(PV(1),'YLim',[-0.1 1.1])
    set(PV,'XLim',[0 max(VPx)])
    set(PV(2),'YLim',[-10 40])
    set(PV(1),'YTick',[-0.1:0.2:1.1])
    set(PV(2),'YTick',[-10:10:40])
    ylabel(PV(1),'Position') % left y-axis
    ylabel(PV(2),'Velocity') % right y-axis

end

%% Separated by ISI graphs

hf8=figure;
idxom = find(trials.c_isi>1000 & trials.c_usdur==0 & trials.c_usnum==us & trials.c_csnum==cs);
if isempty(idxom)
    sepISI(trials);
end

%% Output

if nargout > 0
    varargout{1}=hf1;
    varargout{2}=hf2;
    varargout{3}=hf3;
    varargout{4}=hf4;
    varargout{5}=hf5;
    varargout{6}=hf6;
    varargout{7}=hf7;
    varargout{8}=hf8;
end