function varargout = sodaPlotPaCo(sodaPar,evalResults,varargin)

standardize = true;
invAxis = repmat(false,[1,sodaPar.nOptPars]);

nRows = size(evalResults,1);
nSamples = sodaPar.nSamples;
iterSelection = nRows+[-5*nSamples+1:0];

authorizedOptions = {'standardize',...
                     'invAxis',...
                     'iterSelection'};

% parse input from varargin here
sodaParsePairs


parCols = sodaPar.parCols;
nSamples = numel(iterSelection);

muRecords = repmat(mean(evalResults(iterSelection,parCols),1),[nSamples,1]);

flag = 0; % standard deviation calculated with n-1 in the divisor

sigmaRecords = repmat(std(evalResults(iterSelection,parCols),flag,1),[nSamples,1]);


invArray = repmat((~invAxis)*1+invAxis*-1,[nSamples,1]);


if standardize
    M = invArray.*(evalResults(iterSelection,parCols)-muRecords)./sigmaRecords;
else
    M = invArray.*evalResults(iterSelection,parCols);
end

minLim = min(M(:));
maxLim = max(M(:));

hold on
for k=sodaPar.parCols
    if invAxis(1,k-1)
        s = '-1\cdot';
    else
        s = '';
    end
    if numel(sodaPar.parNamesTex)>=(k-1) && ~isempty(sodaPar.parNamesTex{k-1})
        arrayOfHandles(k-1,1) = text(k,minLim+(maxLim-minLim)*1.05,...
            [s,sodaPar.parNamesTex{k-1}],...
            'interpreter','tex',...
            'horizontalalign','center',...
            'verticalalignment','middle');
    else
        arrayOfHandles(k-1,1) = text(k,minLim+(maxLim-minLim)*1.05,...
            [s,sodaPar.parMap{k-1}],...
            'interpreter','none',...
            'horizontalalign','center',...
            'verticalalignment','middle');
    end
end


arrayOfHandles(sodaPar.nOptPars+[1:sodaPar.nOptPars],1) =...
    plot([sodaPar.parCols;sodaPar.parCols],[minLim;maxLim],...
    'color',0.8*[1,1,1]);

arrayOfHandles(2*sodaPar.nOptPars+[1:nSamples],1) = plot(sodaPar.parCols,M,'-k');

set(gca,'xlim',[min(sodaPar.parCols),max(sodaPar.parCols)]+[-1,1]*0.5)
set(gca,'ylim',[minLim,maxLim])
set(gca,'xtick',sodaPar.parCols,'xticklabel',{})


if standardize
    arrayOfHandles(end+1,1) = ylabel('normalized parameter value');
else
    arrayOfHandles(end+1,1) = ylabel('parameter value');
end



set(gcf,'numbertitle','off','name',mfilename)




if nargout==1
    varargout = arrayOfHandles;
end
