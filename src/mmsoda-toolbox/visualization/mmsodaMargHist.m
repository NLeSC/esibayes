function varargout=mmsodaMargHist(conf,evalResults,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaMargHist.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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


if nargin == 0
    disp(['% Function ',mfilename,' usage'])
    disp('% varargout = mmsodaMargHist(conf,evalResults,varargin)')
    varargout = {};
    return
end

% assign default options:
histMode='absolute';
nBins = min([50,round(conf.nSamples/5)]);
N = min([size(evalResults,1),5*conf.nSamples]);
iterSelection = size(evalResults,1)+(-N+1:0);
nHistory = 5*conf.nSamples;
clear N
%faceColor = [0.42,0.84,0];
faceColor = [0.9373,0.6863,0.1608];
edgeColor = faceColor;
fixedBinEdges = false;
showNumberOfPoints = true;
xScale={};
yScale={};
printToFile = false;
printToPNG = false;
printToEPS = false;

authorizedOptions = {'histMode',...
                     'nBins',...
                     'iterSelection',...
                     'faceColor',...
                     'edgeColor',...
                     'fixedBinEdges',...
                     'showNumberOfPoints',...
                     'xScale',...
                     'yScale',...
                     'printToFile',...
                     'printToPNG',...
                     'printToEPS',...
                     'nHistory',...
                     'showNumberOfPoints'};

% overrule default options with user-specified options:
mmsodaParsePairs()



if ischar(nHistory)
    % nHistory is the number of parameter sets that will
    % be included, counting from the end of the record. The
    % switch below converts any textual value to the corresponding
    % number.
    switch nHistory
        case 'all'
            nHistory = size(evalResults,1);
            numberOfPointsStr = [char(39),'all parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
        case 'nSamples'
            nHistory = conf.nSamples;
            numberOfPointsStr = [char(39),'last ',num2str(nHistory),' parameter sets',char(39)];
        case 'noinit'
            nHistory = size(evalResults,1)-conf.nSamples;
            numberOfPointsStr = [char(39),'all parameter sets except burn-in',char(39), ' (N = ',num2str(nHistory),')'];
        case {'50%+','H2'}
            nHistory = floor(size(evalResults,1)*0.50);
            numberOfPointsStr = [char(39),'H2-parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
        case {'75%+','Q4'}
            nHistory = floor(size(evalResults,1)*(1.00-0.75));
            numberOfPointsStr = [char(39),'Q4-parameter sets',char(39), ' (N = ',num2str(nHistory),')'];
    end
else
    numberOfPointsStr = [char(39),'last ',num2str(min([size(evalResults,1),nHistory])),' parameter sets',char(39)];
end


rStart = max(1,size(evalResults,1)-nHistory+1);
rEnd = size(evalResults,1);

if rStart>rEnd
    % this happens when the visualization routine is called for
    % the first time when nHistory is 'noinit' or 0
    return
end

iterSelection = rStart:rEnd;

nPoints = numel(iterSelection);

M = evalResults(iterSelection,:);
H=repmat(NaN,[numel(conf.parCols),1]);


for r=1:numel(conf.parCols)
    xScale2{r,1}=r;
    xScale2{r,2}=cellfind(xScale,r);
    yScale2{r,1}=r;
    yScale2{r,2}=cellfind(yScale,r);
end
xScale = xScale2;
yScale = yScale2;
clear xScale2
clear yScale2



for p=conf.parCols-1

    H(p)=subplot(conf.nOptPars,1,p);

    a = conf.parSpaceLoBound(p);
    b = conf.parSpaceHiBound(p);

    if fixedBinEdges
        c = a;
        e = b;
    else
        c = min(M(:,p+1));
        d = max(M(:,p+1));
        e = d+(d-c)*1e-8;
    end

    clear d

    binEdges = linspace(c,e,nBins+1);
    binWidth = binEdges(2)-binEdges(1);

    switch histMode
        case 'absolute'
            histcResult = histc(M(:,p+1),binEdges);
        case 'relative'
            nRecords = size(M,1);
            histcResult = histc(M(:,p+1),binEdges)/binWidth/nRecords;
        otherwise
            error(['Unknown option in function ', mfilename])
    end
    [xb,yb]=stairs([c,binEdges,e],[0,histcResult',0]);
    patchHandle = patch(xb,yb,'k');
    set(patchHandle,'FaceColor',faceColor,'EdgeColor',edgeColor)
    set(gca,'xscale',xScale{p,2},'yscale',yScale{p,2})
    set(gca,'xlim',[c,e])

    box on

    if isfield(conf,'parNamesTex')&&...
            numel(conf.parNamesTex)>=p&&...
            ~isempty(conf.parNamesTex{p})
        if showNumberOfPoints
            title([conf.parNamesTex{p},' ',numberOfPointsStr],'interpreter','tex')
        else
            title(conf.parNamesTex{p},'interpreter','tex')
        end
    else
        if showNumberOfPoints
            title([conf.parNames{p},' ',numberOfPointsStr],'interpreter','none')
        else
            title(conf.parNames{p},'interpreter','none')
        end
    end

    if p==conf.parCols(end)-1
            xlabel('parameter value')
    end
    switch histMode
        case 'absolute'
            ylabel('count')
        case 'relative'
            ylabel('frequency')
        otherwise
            warning('Unrecognized histMode.')
    end

end

set(gcf,'name',mfilename,'numbertitle','off')






if nargout==2
    varargout{1}=binEdges;
    varargout{2}=histcResult;
elseif nargout==3
    varargout{1}=binEdges;
    varargout{2}=histcResult;
    varargout{3}=H;
end

if printToPNG||printToFile
    print(mfilename,'-dpng','-r300')
end
if printToEPS||printToFile
    print(mfilename,'-depsc','-r300')
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

function scaleType=cellfind(C,subplotIx)
scaleType='linear';
for r=1:size(C,1)
    if C{r,1}==subplotIx
        scaleType = C{r,2};
        return
    end
end
