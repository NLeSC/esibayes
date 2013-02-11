function mmsodaAnalyzeTimings(varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaAnalyzeTimings.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% 0 matlabmain start in matlabmain.m
%
% 1 receivevar start in receivevar.m
% 2 receivevar end in receivevar.m
%
% 3 sendvar start in sendvar.m
% 4 sendvar end in sendvar.m
%
% 5 gettask start in gettask.m
% 6 gettask end in gettask.m
%
% 7 puttask start in puttask.m
% 8 puttask end in puttask.m
%
% 9 putresult start in putresult.m
% 10 putresult end in putresult.m
%
% 31 hlp_serialize start in sendvar.m
% 32 hlp_serialize end in sendvar.m
% 33 mm_send start in sendvar.m
% 34 mm_send end in sendvar.m
%
% 35 mm_receive start in receivevar.m
% 36 mm_receive end in receivevar.m
% 37 hlp_deserialize start in receivevar.m
% 38 hlp_deserialize end in receivevar.m
%
% 39 wait start in gettask.m
% 40 wait end in gettask.m
%
% 41 receivevar start in runmpirank0.m
% 42 receivevar end in runmpirank0.m
%



bottomLayerHeight = 0.8;
topLayerHeight = 0.2;
vertSep = 0.2;
bgColor = [0.12,0.18,0.24];
showLegend = true;

colorTable = [ 0.51, 0.17, 0.00;...
    0.75, 0.04, 0.38;...
    0.12, 0.15, 0.79;...
    0.92, 0.98, 0.12;...
    1.00, 0.59, 0.04;...
    0.39, 0.64, 0.17;...
    0.10, 0.98, 0.66;...
    0.27, 0.80, 0.84];


startFrom = 0.0;
endAt = 10.0;
showHost = true;
showPID = true;

authorizedOptions = {'bottomLayerHeight',...
    'topLayerHeight',...
    'vertSep',...
    'bgColor',...
    'showLegend',...
    'colorTable',...
    'startFrom',...
    'endAt',...
    'showHost',...
    'showPID'};

mmsodaParsePairs()

colorTable = cat(1,colorTable,bgColor);
if showLegend
    
    h2 = axes('Position',[0.02,0.81,0.96,0.17]);
    h1 = axes('Position',[0.02,0.05,0.96,0.75]);
    
else
    
    h1 = axes('Position',[0.02,0.05,0.96,0.98]);
    
end
if (max([bottomLayerHeight,topLayerHeight]) + vertSep) ~=1
    warning('max([bottomLayerHeight,topLayerHeight]) and vertSep should sum to unity.')
end

bandHeight = (max([topLayerHeight,bottomLayerHeight]) + vertSep);

min_time = startFrom;
max_time = endAt;

counter=0;
anotherfile=true;
while anotherfile
    fn = sprintf('./results/timing_%03d.mat',counter);
    try
        load(fn);
        if counter==0
            reftime = timing.starttimeStr;
            xOffset = 0;
        else
            xOffset = (datenum(timing.starttimeStr)-datenum(reftime))*86400;
        end
    catch err
        if strcmp(err.identifier,'MATLAB:load:couldNotReadFile')
            anotherfile=false;
        else
            error('Unknown error occurred during loading of the timings files.')
        end
    end
    
    
    if anotherfile
        
        waiting=0;
        counter=counter+1;
        
        
        for iStart=1:timing.counter
            if (timing.timer(iStart)>min_time) && (timing.timer(iStart)<max_time)
                if (mod(timing.code(iStart),2)==1)
                    % search for ending of block
                    for iEnd=iStart+1:timing.counter
                        if (timing.code(iEnd)==(timing.code(iStart)+1))
                            endtime=timing.timer(iEnd);
                            if (endtime>max_time)
                                endtime=max_time;
                            end
                            break;
                        end
                    end
                end
                height=0.0;
                color=[1.0,1.0,1.0];
                switch timing.code(iStart)
                    case 1
                        height = bottomLayerHeight;
                        color = colorTable(1,1:3);
                        
                    case 3
                        height = bottomLayerHeight;
                        color = colorTable(2,1:3);
                        
                    case 31
                        height = topLayerHeight;
                        color = colorTable(3,1:3);
                        
                    case 33
                        height = topLayerHeight;
                        color = colorTable(4,1:3);
                        
                    case 35
                        height = topLayerHeight;
                        switch waiting
                            case 0
                                color = colorTable(5,1:3);
                                
                            case 1
                                color = colorTable(6,1:3);
                                
                            case 2
                                color = colorTable(7,1:3);
                                
                        end
                        
                    case 37
                        height = topLayerHeight;
                        color = colorTable(8,1:3);
                        
                    case 39
                        height=0.0;
                        waiting=1;
                        
                    case 40
                        height=0.0;
                        waiting=0;
                        
                    case 41
                        height=0.0;
                        waiting=2;
                        
                    case 42
                        height=0.0;
                        waiting=0;
                        
                end
                if (height>0)&&(endtime>timing.timer(iStart))
                    x = timing.timer(iStart) + xOffset;
                    y = bandHeight * (counter-1) + 0.5*bandHeight - 0.5*height;
                    w = endtime-timing.timer(iStart);
                    h = height;
                    rectangle('Position',[x,y,w,h],'FaceColor',color,'EdgeColor',color);
                end
            end
        end
        str = sprintf(' #%d',counter);        
        if showHost
            str = [str,' HOST=',timing.host];
        end
        if showPID
            str = [str,' PID=',timing.pid];
        end
        if exist('x','var')~=0        
            text(startFrom,counter-0.5,str,'color',[1,1,1],'horizontalalign','left')
        else
            text(startFrom,counter-0.5,[str,' no events'],'color',[1,1,1],'horizontalalign','left')
        end

        clear timing
        clear x y w h
        
    end % if anotherfile
    
end % while anotherfile


set(gca,'color',bgColor,'xlim',[startFrom,endAt])

nProcesses = counter;
% yAxisLabels = cell(1,nProcesses);
% for iProcess = 1:nProcesses
%     yAxisLabels{iProcess}=sprintf('process #%d',iProcess);
% end
set(gca,'ytick',(0.5:1.0:nProcesses-0.5)*bandHeight,'yticklabel','','ylim',[0,nProcesses])
xlabel(['Elapsed time [s] since ',datestr(datenum(reftime),'mmm DD, YYYY HH:MM:SS'),' UTC'])
box on


if showLegend
    axes(h2)
    set(gca,'color','none','xtick',[],'ytick',[],'ydir','reverse','visible','off')
    
    L = 0;
    B = 0;
    W = 1;
    H = 0.9;
    S = 0.1;
    
    labels = {'receivevar',...
        'sendvar',...
        'hlp\_serialize',...
        'mm\_send',...
        'mm\_receive, waiting==0',...
        'mm\_receive, waiting==1',...
        'mm\_receive, waiting==2',...
        'hlp\_deserialize',...
        'background color'};
    
    for iEntry = 0+(1:3)
        
        rectangle('Position',[L,(iEntry-1)*(H+S),W,H],'FaceColor',colorTable(iEntry,1:3),'EdgeColor',[0,0,0]);
        text(L + 1.1*W,(iEntry-1)*(H+S),labels{iEntry},'horizontalalign','left','verticalalign','top','interpreter','tex')
        
    end
    for iEntry = 3+(1:3)
        
        rectangle('Position',[5.0+L,(iEntry-1-3)*(H+S),W,H],'FaceColor',colorTable(iEntry,1:3),'EdgeColor',[0,0,0]);
        text(5.0 + L + 1.1*W,(iEntry-1-3)*(H+S),labels{iEntry},'horizontalalign','left','verticalalign','top','interpreter','tex')
        
    end
    for iEntry = 6+1:size(colorTable,1)
        
        rectangle('Position',[10.0+L,(iEntry-1-6)*(H+S),W,H],'FaceColor',colorTable(iEntry,1:3),'EdgeColor',[0,0,0]);
        text(10.0 + L + 1.1*W,(iEntry-1-6)*(H+S),labels{iEntry},'horizontalalign','left','verticalalign','top','interpreter','tex')
        
    end
    set(gca,'xlim',[0,15],'ylim',[-1,5])
    
    box on
    
end


axes(h1)


