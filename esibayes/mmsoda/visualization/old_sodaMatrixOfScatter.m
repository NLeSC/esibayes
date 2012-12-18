function varargout = sodaMatrixOfScatter(sodaPar,typeStr,sequences,metropolisRejects,varargin)



authorizedOptions = sort({'showRejects',...
                          'lightFactor',...
                          'markerSeq',...
                          'markersizeSeq',...
                          'linestyleSeq',...
                          'markerRej',...
                          'markersizeRej',...
                          'linestyleRej',...
                          'nHistory',...
                          'colorList',...
                          'hideBadScore',...
                          'bgColor',...
                          'xTrue',...
                          'yTrue',...
                          'excludeDiag',...
                          'excludeTriup',...
                          'objTexName',...
                          'objTexNames',...
                          'fontsize',...
                          'showNumberOfPoints'});

if nargin==0
    optionsStr = '';
    for iOption = 1:numel(authorizedOptions)
        optionsStr = [optionsStr,' % ',char(39),authorizedOptions{iOption},char(39),char(10)];
    end
    disp([char(10),' % Usage is: ',char(10),...
             ' % sodaMatrixOfScatter(sodaPar,typeStr,sequences,metropolisRejects,<param>,<value>)',char(10),...
             ' % ',char(10),...
             ' % valid options are:',char(10),optionsStr,char(10)])
    return
end

fontsize=10;
showRejects = true;
lightFactor = 'none';
markerSeq = 's';
if uimatlab || isdeployed
    markersizeSeq = 4;
    markersizeRej = 4;
elseif uioctave
    markersizeSeq = 3;
    markersizeRej = 3;
else
end
linestyleSeq = 'none';
markerRej = 's';
linestyleRej = 'none';
nHistory = 1*sodaPar.nSamplesPerCompl*sodaPar.nCompl; % total number of points
colorList = sodaMakeColors(sodaPar);
hideBadScore = false;
bgColor = [1,1,1];
xTrue = false;
yTrue = false;
useDefaultObjTexName = sodaPar.isSingleObjective && ~isfield(sodaPar,'objTexName') ||...
                       sodaPar.isMultiObjective && ~isfield(sodaPar,'objTexNames');
showNumberOfPoints = true;


if sodaPar.isSingleObjective && useDefaultObjTexName
    defaultObjTexName = {'log likelihood'};
elseif sodaPar.isMultiObjective && useDefaultObjTexName
    defaultObjTexName = {'pareto score'};
else
end
    

% % overrule default options with user-specified options:
% sodaParsePairs

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


nSequences = sodaPar.nCompl;
nCompl = nSequences;
nPars = sodaPar.nOptPars;
evalCol = sodaPar.evalCol;
parCols = sodaPar.parCols;
objCol = sodaPar.objCol;
nSamples = sodaPar.nSamples;
nSamplesPerCompl = sodaPar.nSamplesPerCompl;


switch typeStr
    case {'obj-par'}
        % plot objective vs parameters
        x = objCol;
        y = parCols;
        if useDefaultObjTexName
            xLabels = defaultObjTexName;
        else
            xLabels = sodaPar.objTexName;
        end
        if isfield(sodaPar,'parNamesTex')
            yLabels = sodaPar.parNamesTex;
        else
            yLabels = sodaPar.parNames;
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'par-obj'}
        % plot parameters vs objectives
        x = parCols;
        y = objCol;
        if isfield(sodaPar,'parNamesTex')
            xLabels = sodaPar.parNamesTex;
        else
            xLabels = sodaPar.parNames;
        end
        if useDefaultObjTexName
            yLabels = defaultObjTexName;
        else
            yLabels = sodaPar.objTexName;
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'par-par'}
        % plot parameters vs parameters
        x = parCols;
        y = parCols;
        if isfield(sodaPar,'parNamesTex')
            xLabels = sodaPar.parNamesTex;
        else
            xLabels = sodaPar.parNames;
        end
        yLabels = xLabels;
        excludeDiag = true;
        excludeTriup = true;
    case {'par-eval'}
        % plot parameters vs model evaluation number
        x = parCols;
        y = evalCol;
        if isfield(sodaPar,'parNamesTex')
            xLabels = sodaPar.parNamesTex;
        else
            xLabels = sodaPar.parNames;
        end
        yLabels = {'model evaluation number'};
        excludeDiag = false;
        excludeTriup = false;
    case {'eval-par'}
        % plot model evaluation number vs parameter
        x = evalCol;
        y = parCols;
        xLabels = {'model evaluation number'};
        if isfield(sodaPar,'parNamesTex')
            yLabels = sodaPar.parNamesTex;
        else
            yLabels = sodaPar.parNames;
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'eval-obj'}
        % plot model evaluation number vs objectives
        x = evalCol;
        y = objCol;
        xLabels = {'model evaluation number'};
        if useDefaultObjTexName
            yLabels = defaultObjTexName;
        else
            yLabels = sodaPar.objTexName;
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'obj-eval'}
        % plot objectives vs model evaluation number
        x = objCol;
        y = evalCol;
        if useDefaultObjTexName
            xLabels = defaultObjTexName;
        else
            xLabels = sodaPar.objTexName;
        end
        yLabels = {'model evaluation number'};
        excludeDiag = false;
        excludeTriup = false;
    otherwise
        disp('Undefined case. Aborting.')
        return
end

% overrule default options with user-specified options:
sodaParsePairs


if ischar(nHistory)
    % nHistory is the number of parameter sets that will
    % be included, counting from the end of the record. The
    % switch below converts any textual value to the corresponding
    % number.
    switch nHistory
        case 'all'
            nHistory = size(sequences,1)*size(sequences,3);
            numberOfPointsStr = [char(39),'all parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
        case 'nSamples'
            nHistory = sodaPar.nSamples;
            numberOfPointsStr = [char(39),'last ',num2str(nHistory),' parameter sets'];
        case 'noinit'
            nHistory = size(sequences,1)*size(sequences,3)-sodaPar.nSamples;
            numberOfPointsStr = [char(39),'all parameter sets except burn-in',char(39), ' (N = ',num2str(nHistory),')'];
        case {'50%+','H2'}
            nHistory = floor(size(sequences,1)*0.50)*nCompl;
            numberOfPointsStr = [char(39),'H2-parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
        case {'75%+','Q4'}
            nHistory = floor(size(sequences,1)*(1.00-0.75))*nCompl;
            numberOfPointsStr = [char(39),'Q4-parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
    end
end


rStart = size(sequences,1)-(nHistory/nCompl)+1;
rEnd = size(sequences,1);

if rStart>rEnd
    % this happens when the visualization routine is called for
    % the first time when nHistory is 'noinit' or 0
    return
end

nX = numel(x);
nY = numel(y);

if hideBadScore

    logiOne = repmat(ismember(1:size(sequences,2),sodaPar.objCol),[size(sequences,1),1,nCompl]);
    logiTwo = sequences == sodaPar.badScore;
    logiThree = metropolisRejects == sodaPar.badScore;

    sequences(logiOne & logiTwo) = NaN;
    metropolisRejects(logiOne & logiThree) = NaN;
end


template = repmat(NaN,nY,nX);
xLimsMin = template;
xLimsMax = template;
yLimsMin = template;
yLimsMax = template;
axHandles = template;
clear template
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

set(gcf,'inverthardcopy','off',...
    'paperpositionmode','auto',...
    'numbertitle','off',...
    'name',[char(39),typeStr,char(39),' MatrixOfScatter (''',...
    upper(sodaPar.modeStr),''') - Figure ',num2str(gcf)])

canvasWidth = 0.9;
canvasHeight = 0.9;
canvasLeft = 0.1;
canvasBottom = 0.1;


if excludeDiag && excludeTriup
    axesWidth = canvasWidth/(nX-1);
    axesHeight = canvasHeight/(nY-1);
    axesWidthScaler = 0.95;
    axesHeightScaler = 0.9;
else
    axesWidth = canvasWidth/nX;
    axesHeight = canvasHeight/nY;
    axesWidthScaler = 0.95;
    axesHeightScaler = 0.9;
end


clf



for iY = 1:nY
    for iX = 1:nX

        if excludeDiag && (iX==iY)
            continue
        end
        if excludeTriup && (iX>iY)
            continue
        end

        L = canvasLeft+(iX-1)*axesWidth;
        B = canvasBottom+(nY-iY)*axesHeight;
        W = axesWidth*axesWidthScaler;
        H = axesHeight*axesHeightScaler;

        axHandles(iY,iX) = axes('position',[L,B,W,H]);
        if uioctave
            % fix octave weirdness:
            set(axHandles(iY,iX),'OuterPosition',get(axHandles(iY,iX),'OuterPosition'),...
                'Position',get(axHandles(iY,iX),'Position'),...
                'ActivePositionProperty','position')
        end

        if showRejects
            for iSequence = 1:nSequences
                markerColor = colorList(iSequence,1:3);
                if strcmp(lightFactor,'none')
                    markerColorLight = 'none';
                else
                    markerColorLight = markerColor+((1.0-markerColor)*lightFactor);
                end
                xData = metropolisRejects(max([rStart,1]):rEnd,x(iX),iSequence);
                yData = metropolisRejects(max([rStart,1]):rEnd,y(iY),iSequence);
                plot(xData,yData,...
                    'marker',markerRej,...
                    'markersize',markersizeRej,...
                    'linestyle',linestyleRej,...
                    'markerfacecolor',markerColorLight,...% lighter shade of markerColor
                    'markeredgecolor',markerColor);
                hold on

                [xLimsMin,xLimsMax,yLimsMin,yLimsMax] = globalLims(xLimsMin,xLimsMax,yLimsMin,yLimsMax,iX,iY,xData,yData);

            end
        end

        for iSequence = 1:nSequences
            markerColor = colorList(iSequence,1:3);
            xData = sequences(max([rStart,1]):rEnd,x(iX),iSequence);
            yData = sequences(max([rStart,1]):rEnd,y(iY),iSequence);
            plot(xData,yData,...
                'marker',markerSeq,...
                'markersize',markersizeSeq,...
                'linestyle',linestyleSeq,...
                'markerfacecolor',markerColor,...
                'markeredgecolor',markerColor);
            hold on
            [xLimsMin,xLimsMax,yLimsMin,yLimsMax] = globalLims(xLimsMin,xLimsMax,yLimsMin,yLimsMax,iX,iY,xData,yData);
        end

        if iscell(xTrue)
            switch typeStr(end-2:end)
                case 'par'
                    plot([1,1]*xTrue{iX},[sodaPar.parSpaceLoBound(iY),sodaPar.parSpaceHiBound(iY)],...
                        'linewidth',2,'linestyle','--','color',0.5*[1,1,1])
                case 'val' %eval
                    plot([1,1]*xTrue{iX},[rStart-1,rEnd]*nSequences+[1,0],...
                        'linewidth',2,'linestyle','--','color',0.5*[1,1,1])
                case 'obj'
                    plot([1,1]*xTrue{iX},[yLimsMin(iY,iX),yLimsMax(iY,iX)],...
                        'linewidth',2,'linestyle','--','color',0.5*[1,1,1])
            end
        end
        if iscell(yTrue)
            switch typeStr(1:3)
                case 'par'
                    plot([sodaPar.parSpaceLoBound(iX),sodaPar.parSpaceHiBound(iX)],[1;1]*yTrue{iY}',...
                        'linewidth',2,'linestyle','--','color',0.5*[1,1,1])
                case 'eva' %eval
                    plot([rStart-1,rEnd]*nSequences+[1,0],[1;1]*yTrue{iY}',...
                        'linewidth',2,'linestyle','--','color',0.5*[1,1,1])
                case 'obj'
                    plot([xLimsMin(iY,iX),xLimsMax(iY,iX)],[1;1]*yTrue{iY}',...
                        'linewidth',2,'linestyle','--','color',0.5*[1,1,1])
            end
        end

        if showNumberOfPoints
            title(numberOfPointsStr,'fontsize',fontsize)
        end

        set(gca,'color',bgColor,'fontsize',fontsize)

        if iY < nY % axes is not on the bottom row
            set(gca,'xticklabel',[])
        end
        if iY == nY % axes is on the bottom row
            xlabel(xLabels{iX},'fontsize',fontsize)
        end
        if iX > 1 % axes is not in the left column
            set(gca,'yticklabel',[])
        end
        if iX == 1 % axes is in the left column
            ylabel(yLabels{iY},'fontsize',fontsize)
        end

    end
end



% set axes limits to global minimum and maximum:
for iY = 1:nY
    for iX = 1:nX
        if excludeDiag && (iX==iY)
            continue
        end
        if excludeTriup && (iX>iY)
            continue
        end

        set(axHandles(iY,iX),'xlim',[xLimsMin(iY,iX),xLimsMax(iY,iX)],...
                             'ylim',[yLimsMin(iY,iX),yLimsMax(iY,iX)])
    end
end



if nargout==1
    varargout{1}=axHandles;
end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function [xLimsMin,xLimsMax,yLimsMin,yLimsMax] = globalLims(xLimsMin,xLimsMax,yLimsMin,yLimsMax,iX,iY,xData,yData)

if isnan(xLimsMin(iY,iX)) || xLimsMin(iY,iX)>min(xData)
    xLimsMin(iY,iX) = min(xData);
end
if isnan(yLimsMin(iY,iX)) || yLimsMin(iY,iX)>min(yData)
    yLimsMin(iY,iX) = min(yData);
end
if isnan(xLimsMax(iY,iX)) || xLimsMax(iY,iX)<max(xData)
    xLimsMax(iY,iX) = max(xData);
end
if isnan(yLimsMax(iY,iX)) || yLimsMax(iY,iX)<max(yData)
    yLimsMax(iY,iX) = max(yData);
end


