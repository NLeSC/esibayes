function varargout = mmsodaMatrixOfScatter(conf,typeStr,sequences,metropolisRejects,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaMatrixOfScatter.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


% % 

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END


% dbstop at 268


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
                          'objTexNames',...
                          'fontsize',...
                          'showNumberOfPoints'});

if nargin==0
    optionsStr = '';
    for iOption = 1:numel(authorizedOptions)
        optionsStr = [optionsStr,' % ',char(39),authorizedOptions{iOption},char(39),char(10)];
    end
    disp([char(10),' % Usage is: ',char(10),...
             ' % mmsodaMatrixOfScatter(conf,typeStr,sequences,metropolisRejects,<param>,<value>)',char(10),...
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
nHistory = 1*conf.nSamplesPerCompl*conf.nCompl; % total number of points
colorList = mmsodaMakeColors(conf);
hideBadScore = false;
bgColor = [1,1,1];
xTrue = false;
yTrue = false;
useDefaultObjTexNames = conf.isSingleObjective && ~isfield(conf,'objTexName') ||...
                       conf.isMultiObjective && ~isfield(conf,'objTexNames');
showNumberOfPoints = true;

if conf.isSingleObjective && useDefaultObjTexNames
    defaultObjTexName = {'log likelihood'};
elseif conf.isMultiObjective && useDefaultObjTexNames
    defaultObjTexNames = cell(1,conf.nObjs);
    for iObj=1:conf.nObjs
        defaultObjTexNames{iObj} = ['obj_',num2str(iObj)];
    end
else
end


% % overrule default options with user-specified options:
% mmsodaParsePairs

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


nSequences = conf.nCompl;
nCompl = nSequences;
nPars = conf.nOptPars;
nObjs = conf.nObjs;
evalCol = conf.evalCol;
parCols = conf.parCols;
llCols = conf.llCols;
objCol = conf.objCol;
paretoCol = conf.paretoCol;
nSamples = conf.nSamples;
nSamplesPerCompl = conf.nSamplesPerCompl;


switch typeStr
    case {'ll-ll'}
        if conf.isSingleObjective
            error([char(39),typeStr,char(39),' not defined for single-objective optimization'])
        end
        % plot objectives vs objectives
        x = llCols;
        y = llCols;
        if useDefaultObjTexNames
            xLabels = defaultObjTexNames;
        else
            xLabels = conf.objTexNames;
        end
        yLabels = xLabels;
        excludeDiag = false;
        excludeTriup = false;
    case {'ll-par'}
        % plot objectives vs parameters
        x = llCols;
        y = parCols;
        if conf.isSingleObjective
            if useDefaultObjTexNames
                xLabels = defaultObjTexName;
            else
                xLabels = conf.objTexName;
            end
        elseif conf.isMultiObjective
            if useDefaultObjTexNames
                xLabels = defaultObjTexNames;
            else
                xLabels = conf.objTexNames;
            end
        else
        end
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            yLabels = conf.parNamesTex;
        else
            yLabels = conf.parNames;
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'par-ll'}
        % plot parameters vs objectives
        x = parCols;
        y = llCols;
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            xLabels = conf.parNamesTex;
        else
            xLabels = conf.parNames;
        end
        if conf.isSingleObjective
            if useDefaultObjTexNames
                yLabels = defaultObjTexName;
            else
                yLabels = conf.objTexName;
            end
        elseif conf.isMultiObjective
            if useDefaultObjTexNames
                yLabels = defaultObjTexNames;
            else
                yLabels = conf.objTexNames;
            end
        else
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'par-par'}
        % plot parameters vs parameters
        x = parCols;
        y = parCols;
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            xLabels = conf.parNamesTex;
        else
            xLabels = conf.parNames;
        end
        yLabels = xLabels;
        excludeDiag = true;
        excludeTriup = true;
    case {'par-eval'}
        % plot parameters vs model evaluation number
        x = parCols;
        y = evalCol;
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            xLabels = conf.parNamesTex;
        else
            xLabels = conf.parNames;
        end
        yLabels = {'model evaluation number'};
        excludeDiag = false;
        excludeTriup = false;
    case {'eval-par'}
        % plot model evaluation number vs parameter
        x = evalCol;
        y = parCols;
        xLabels = {'model evaluation number'};
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            yLabels = conf.parNamesTex;
        else
            yLabels = conf.parNames;
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'par-pareto'}
        if conf.isSingleObjective
            error([char(39),typeStr,char(39),' not defined for single-objective optimization'])
        end
        % plot parameters vs pareto
        x = parCols;
        y = paretoCol;
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            xLabels = conf.parNamesTex;
        else
            xLabels = conf.parNames;
        end
        yLabels = {'Pareto score'};
        excludeDiag = false;
        excludeTriup = false;
    case {'par-obj'}
        % plot parameters vs obj score
        if conf.isMultiObjective
            error([char(39),typeStr,char(39),' not defined for multi-objective optimization'])
        end
        x = parCols;
        y = objCol;
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            xLabels = conf.parNamesTex;
        else
            xLabels = conf.parNames;
        end
        yLabels = {'log likelihood'};
        excludeDiag = false;
        excludeTriup = false;
    case {'obj-par'}
        % plot obj score vs parameters 
        if conf.isMultiObjective
            error([char(39),typeStr,char(39),' not defined for multi-objective optimization'])
        end
        x = objCol;
        y = parCols;
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            yLabels = conf.parNamesTex;
        else
            yLabels = conf.parNames;
        end
        xLabels = {'log likelihood'};
        excludeDiag = false;
        excludeTriup = false;
    case {'pareto-par'}
        % plot pareto vs parameters
        if conf.isSingleObjective
            error([char(39),typeStr,char(39),' not defined for single-objective optimization'])
        end
        x = paretoCol;
        y = parCols;
        xLabels = {'Pareto score'};
        if isfield(conf,'parNamesTex') && ~isempty(conf.parNamesTex)
            yLabels = conf.parNamesTex;
        else
            yLabels = conf.parNames;
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'pareto-ll'}
        % plot pareto vs objectives
        if conf.isSingleObjective
            error([char(39),typeStr,char(39),' not defined for single-objective optimization'])
        end
        x = paretoCol;
        y = llCols;
        xLabels = {'Pareto score'};
        if conf.isSingleObjective
            if useDefaultObjTexNames
                yLabels = defaultObjTexName;
            else
                yLabels = conf.objTexName;
            end
        elseif conf.isMultiObjective
            if useDefaultObjTexNames
                yLabels = defaultObjTexNames;
            else
                yLabels = conf.objTexNames;
            end
        else
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'ll-pareto'}
        % plot objectives vs pareto
        if conf.isSingleObjective
            error([char(39),typeStr,char(39),' not defined for single-objective optimization'])
        end
        x = llCols;
        y = paretoCol;
        if conf.isSingleObjective
            if useDefaultObjTexNames
                xLabels = defaultObjTexName;
            else
                xLabels = conf.objTexName;
            end
        elseif conf.isMultiObjective
            if useDefaultObjTexNames
                xLabels = defaultObjTexNames;
            else
                xLabels = conf.objTexNames;
            end
        else
        end
        yLabels = {'Pareto score'};
        excludeDiag = false;
        excludeTriup = false;
    case {'eval-ll'}
        % plot model evaluation number vs objectives
        x = evalCol;
        y = llCols;
        xLabels = {'model evaluation number'};
        if conf.isSingleObjective
            if useDefaultObjTexNames
                yLabels = defaultObjTexName;
            else
                yLabels = conf.objTexName;
            end
        elseif conf.isMultiObjective
            if useDefaultObjTexNames
                yLabels = defaultObjTexNames;
            else
                yLabels = conf.objTexNames;
            end
        else
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'eval-obj'}
        % plot model evaluation number vs objectives
        x = evalCol;
        y = objCol;
        xLabels = {'model evaluation number'};
        if conf.isSingleObjective
            yLabels = {'log likelihood'};
        elseif conf.isMultiObjective
            yLabels = {'Pareto score'};
        else
        end
        excludeDiag = false;
        excludeTriup = false;
    case {'ll-eval'}
        % plot objectives vs model evaluation number
        x = llCols;
        y = evalCol;
        if conf.isSingleObjective
            if useDefaultObjTexNames
                xLabels = defaultObjTexName;
            else
                xLabels = conf.objTexName;
            end
        elseif conf.isMultiObjective
            if useDefaultObjTexNames
                xLabels = defaultObjTexNames;
            else
                xLabels = conf.objTexNames;
            end
        else
        end
        yLabels = {'model evaluation number'};
        excludeDiag = false;
        excludeTriup = false;
    otherwise
        disp('Undefined case. Aborting.')
        return
end

% overrule default options with user-specified options:
mmsodaParsePairs


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
            nHistory = conf.nSamples;
            numberOfPointsStr = [char(39),'last ',num2str(nHistory),' parameter sets',char(39)];
        case 'noinit'
            nHistory = size(sequences,1)*size(sequences,3)-conf.nSamples;
            numberOfPointsStr = [char(39),'all parameter sets except burn-in',char(39), ' (N = ',num2str(nHistory),')'];
        case {'50%+','H2'}
            nHistory = floor(size(sequences,1)*0.50)*nCompl;
            numberOfPointsStr = [char(39),'H2-parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
        case {'75%+','Q4'}
            nHistory = floor(size(sequences,1)*(1.00-0.75))*nCompl;
            numberOfPointsStr = [char(39),'Q4-parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
    end
else
    numberOfPointsStr = [char(39),'last ',num2str(nHistory),' parameter sets',char(39)];
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

    logiOne = repmat(ismember(1:size(sequences,2),conf.llCols),[size(sequences,1),1,nCompl]);
    logiTwo = sequences == conf.badScore;
    logiThree = metropolisRejects == conf.badScore;

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
    upper(conf.modeStr),''') - Figure ',num2str(gcf)])

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
                    plot([1,1]*xTrue{iX},[conf.parSpaceLoBound(iY),conf.parSpaceHiBound(iY)],...
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
                    plot([conf.parSpaceLoBound(iX),conf.parSpaceHiBound(iX)],[1;1]*yTrue{iY}',...
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


