function mmsodaPlotGelmanRubin(conf,critGelRub,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPlotGelmanRubin.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>



view = 'zoom';
printToFile = false;
printToPNG = false;
printToEPS = false;

authorizedOptions = {'view','printToFile','printToPNG','printToEPS'};

% parse input from varargin here
mmsodaParsePairs

if ~any(strcmp(view,{'zoom','full'}))
    error(['view should be one of ',char(39),...
        'zoom',char(39),' or ',char(39),...
        'full',char(39),'.'])
end

set(gcf,'numbertitle','off','name',mfilename)

% r = size(critGelRub,1);
% yLimMin = 1.0;
% yLimMax = 1.02;%conf.critGelRubConv;

nRows = size(critGelRub,1);
n = max([1,nRows-conf.nGelRub+1]);

for p=2:size(critGelRub,2)
    
    subplot(conf.nOptPars,1,p-1)
    
    yLimMin = min(critGelRub(n:nRows,p));
    yLimMax = max(critGelRub(n:nRows,p));
    
    
    plot(critGelRub(:,1),critGelRub(:,p),'-b.')
    hold on
    plot([0;conf.nModelEvalsMax],ones(2,1)*conf.critGelRubConvd,...
        'color',[0,0.5,0],'linestyle','--')
    hold off
    set(gca,'xlim',[0,critGelRub(end,1)])
    
    if strcmp(view,'zoom')
        if yLimMin<yLimMax
            set(gca,'ylim',[yLimMin,yLimMax])
            set(gca,'ytick',[yLimMin,yLimMax])
        end
    end
    
    if isfield(conf,'parNamesTex')&&...
            numel(conf.parNamesTex)>=(p-1)&&...
            ~isempty(conf.parNamesTex{p-1})
        title(conf.parNamesTex{p-1},'interpreter','tex')
    else
        title(conf.parNames{p-1},'interpreter','none')
    end
    
    if p==size(critGelRub,2)
        xlabel('model evaluations')
    end
    
    if conf.parCols(end)-1>3
        ylabel('$\sqrt{SR}$','interpreter','LaTeX')
    else
        ylabel('Gelman-Rubin convergence')
    end
    
    
    
end



if printToPNG||printToFile
    print(mfilename,'-dpng','-r300')
end
if printToEPS||printToFile
    print(mfilename,'-depsc','-r300')
end

