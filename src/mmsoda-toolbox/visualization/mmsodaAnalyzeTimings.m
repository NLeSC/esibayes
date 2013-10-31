function mmsodaAnalyzeTimings(varargin)



showLegend = true;
bottomLayerHeight = 0.8;
topLayerHeight = 0.2;
vertSep = 0.2;
bgColor = [0.12,0.18,0.24];
showHost = true;
showPID = true;
showRank = true;


authorizedOptions = {'showLegend',...
    'bottomLayerHeight',...
    'topLayerHeight',...
    'vertSep',...
    'bgColor',...
    'showHost',...
    'showPID',...
    'showRank'};


mmsodaParsePairs()

olive = [0.00, 0.50, 0.00];
lime = [0.67, 1.00, 0.00];
magenta = [0.75, 0.04, 0.38];
blue = [0.12, 0.15, 0.79];
lightgray = [0.71,0.71,0.71];
cyan = [ 0.27, 0.80, 0.84];
textColor = [1,1,1];
textColorBackground = [0,0,0];

events = { 1, 2,'receivevar in receivevar.c',    0.4,{'FaceColor',olive,'EdgeColor',olive};... 
           3, 4,'sendvar in sendvar.c',          0.4,{'FaceColor',magenta,'EdgeColor',magenta};...
          31,32,'SerializeVar in sendvar.c',     0.1,{'FaceColor',blue,'EdgeColor',blue};...
          33,34,'MPI_Send in sendvar.c',         0.1,{'FaceColor',lightgray,'EdgeColor',lightgray};...
          35,36,'MPI_Recv in receivevar.c',      0.1,{'FaceColor',lime,'EdgeColor',lime};...
          37,38,'DeserializeVar in receivevar.c',0.1,{'FaceColor',cyan,'EdgeColor',cyan}};  


timingsDirectory = 'results';

if showLegend
    
    h2 = axes('Position',[0.02,0.81,0.96,0.17],'Color','none');
    axis off
    
    h1 = axes('Position',[0.02,0.05,0.96,0.75],'Color',bgColor);
    
else
    
    h1 = axes('Position',[0.02,0.05,0.96,0.93],'Color',bgColor);
    
end


d = dir(timingsDirectory);
nItems = numel(d);
nEvents = size(events,1);

eventOccurred = repmat(false,[nEvents,1]);

mpiRankMax = -Inf;
mpiRankMin = +Inf;

IdontSeeTheTimingFiles = true;

for iItem = 1:nItems
    
    fname = d(iItem).name;
    if isTimingFile(fname)

        IdontSeeTheTimingFiles = false;
        
        load(fullfile(timingsDirectory,fname),'timing');
        
        mpiRankMin = min([mpiRankMin,timing.mpirank]);
        mpiRankMax = max([mpiRankMax,timing.mpirank]);
        
        nCodes = numel(timing.code);
        for iEvent = 1:nEvents
            codeInit = events{iEvent,1};
            codeTerm = events{iEvent,2};
            
            for indexFrom = find(timing.code==codeInit)
                
                    for indexTo = indexFrom+1:nCodes
                        if timing.code(indexTo) == codeTerm
                            eventOccurred(iEvent) = true;
                            break
                        end
                    end
                    
                    xStart = timing.timer(indexFrom);
                    xEnd = timing.timer(indexTo);
                    
                    halfBandHeight = events{iEvent,4};
                    eventStyle = events(iEvent,5);
                    drawRectangle(xStart,...
                                  xEnd,...
                                  timing.mpirank-halfBandHeight,...
                                  timing.mpirank+halfBandHeight,...
                                  eventStyle)
            end
        end
        
        str = '';        
        if showRank
            str = [str,'RANK=',num2str(timing.mpirank)];
        end
        if showHost
            str = [str,' HOST=',timing.host];
        end
        if showPID
            str = [str,' PID=',timing.pid];
        end
        if any(eventOccurred)
            text(0,timing.mpirank,str,...
                'color',textColor,...
                'BackgroundColor',textColorBackground,...
                'horizontalalign','left',...
                'verticalalign','middle',...
                'Margin',1,...
                'Interpreter','none')
        else
            text(0,timing.mpirank,[str,' no events'],...
                'color',textColor,...
                'BackgroundColor',textColorBackground,...
                'horizontalalign','left',...
                'verticalalign','middle',...
                'Margin',1,...
                'Interpreter','none')
        end

        
    end
    
end

if IdontSeeTheTimingFiles
    error('I don''t see any timing files.')
end


set(gca,'ylim',[mpiRankMin-0.5,mpiRankMax+0.5],...
    'ytick',[])

for iEvent=1:nEvents
    if ~eventOccurred(iEvent)
        disp(['I did not see any events of type ''',events{iEvent,3},'''.'])
    end
    
end
xlabel('time since reference [s]')

if showLegend
    drawLegend(h2,events,eventOccurred)
end




function IO = isTimingFile(fname)

IO = numel(fname)==14 && strcmp(fname([1:7,11:14]),'timing_.mat');




function drawRectangle(xStart,xEnd,yStart,yEnd,patchProps)



xp = [xStart,xEnd,xEnd,xStart,xStart];
yp = [yEnd,yEnd,yStart,yStart,yEnd];

h=patch(xp,yp,'k');
set(h,patchProps{1}{:});



function drawLegend(h,events,eventOccurred)

axes(h)
hold on
nEvents = size(events,1);
nCols = 3;

set(gca,'xlim',[0,nCols+1],'ydir','reverse')

M = [1,2,1;...
     2,1,1;...
     3,1,2;...
     4,1,3,;...
     5,2,2,;...
     6,2,3];

for iEvent = 1:nEvents
%     iRow = floor((iEvent-1)/nCols);
%     iCol = mod(iEvent-1,nCols)+1;

    iRow = M(iEvent,2);
    iCol = M(iEvent,3);

    if eventOccurred(iEvent)
        drawRectangle(iCol-0.45,iCol+0.45,iRow-0.45,iRow+0.45,events(iEvent,5))
        text(iCol,iRow,events{iEvent,3},'Interpreter','none',...
                                         'horizontalalignment','center',...
                                         'verticalalignment','middle')
    end
    
end

hold off





