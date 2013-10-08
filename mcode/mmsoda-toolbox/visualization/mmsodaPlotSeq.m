function varargout = mmsodaPlotSeq(conf,sequences,metropolisRejects,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPlotSeq.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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


xLim = [1,max(max(sequences(:,conf.evalCol,:)))];
xScale = repmat({'lin'},[conf.nOptPars,1]);
yScale = repmat({'lin'},[conf.nOptPars,1]);


plotMode = 'subaxes';
printToFile = false;
printToPNG = false;
printToEPS = false;
checkered = false;
showRejects = true;

if uimatlab || isdeployed
    markersizeSeq = 4;
    markersizeRej = 4;
elseif uioctave
    markersizeSeq = 3;
    markersizeRej = 3;
else
end

authorizedOptions={'plotMode',...
                   'xScale',...
                   'yScale',...
                   'printToFile',...
                   'printToPNG',...
                   'printToEPS',...
                   'checkered',...
                   'showRejects',...
                   'xLim'};

% overrule default options with user-specified options:
mmsodaParsePairs
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


nPars = numel(conf.parCols);
plotHandlesSequences = repmat(NaN,conf.nCompl,nPars);

colorList = mmsodaMakeColors(conf);

iGeneration = (size(sequences,1)-conf.nSamplesPerCompl)/conf.nOffspringPerCompl;
calcConvFromIter = (conf.nSamplesPerCompl +...
                   floor(iGeneration*(1-conf.convUseLastFraction))*...
                   conf.nOffspringPerCompl)*conf.nCompl;


for p=1:nPars

    switch plotMode
        case 'figures'
            figure('name',[mfilename,':',conf.parNames{p}],'numbertitle','off')
        case 'subaxes'
            set(gcf,'name',mfilename,'numbertitle','off')
            subaxes(nPars,1,p,'borderBottom',0.02,...
                              'spacingRight',0.01,...
                              'spacingLeft',0.02)
        case 'subplots'
            set(gcf,'name',mfilename,'numbertitle','off')
            subplot(nPars,1,p)
    end


    if checkered

        nStratRand = floor(conf.nSamples^(1/conf.nOptPars));
        yv = linspace(conf.parSpaceLoBound(p),conf.parSpaceHiBound(p),nStratRand+1);
        nBlocksX = (nStratRand^conf.nOptPars)/(nStratRand^(conf.nOptPars-p));

        for ix = 1:nBlocksX% block counter x dir

            XW = nStratRand^(conf.nOptPars-p);
            XLB = (ix-1)*XW + 0.5;
            XRB = ix*XW + 0.5;
            XRT = XRB;
            XLT = XLB;

            for iy = 1:nStratRand

                YLB = yv(iy);
                YRB = YLB;
                YRT = yv(iy+1);
                YLT = YRT;

                hp=patch([XLB,XRB,XRT,XLT,XLB],[YLB,YRB,YRT,YLT,YLB],'k');
                if (isodd(ix)&isodd(iy)) | (~isodd(ix)&~isodd(iy))
                    set(hp,'edgecolor','none','facecolor',[1,1,1]*0.9)
                else
                    set(hp,'edgecolor','none','facecolor',[1,1,1])
                end
                hold on

            end

        end
    end


    nEvals = max(max(shiftdim(sequences(:,1,:),2)));
    yLim = [conf.parSpaceLoBound(p),conf.parSpaceHiBound(p)];
    x = [conf.nSamples:conf.nOffspring:nEvals]+0.5;
    plotHandlesGenerations = plot([x;x],yLim,'color',[0.9,0.9,0.9]);
    hold on
    plotHandlesGenerations = [plotHandlesGenerations;...
        plot([1;1]*calcConvFromIter+0.5,yLim,'color',[0.5,0.5,0.5])];
    set(gca,'xscale',xScale{p,2},'yscale',yScale{p,2})
    for k=1:conf.nCompl

        if showRejects
            plotHandlesRejects(k,p) = plot(metropolisRejects(:,1,k),metropolisRejects(:,p+1,k),'s',...
                                          'markersize',markersizeRej,...
                                     'markerfacecolor','w',...
                                     'markeredgecolor',colorList(k,:));
        end

        plotHandlesSequences(k,p) = plot(sequences(:,1,k),sequences(:,p+1,k),'s',...
                                      'markersize',markersizeSeq,...
                                 'markerfacecolor',colorList(k,:),...
                                 'markeredgecolor',colorList(k,:));
    end
    set(gca,'ylim',yLim,'xlim',xLim,'layer','top')


    if isfield(conf,'parNamesTex')&&...
            numel(conf.parNamesTex)>=(p)&&...
            ~isempty(conf.parNamesTex{p})
        ylabel(conf.parNamesTex{p},'interpreter','tex',...
            'rotation',90,'horizontalalignment','right')
    else
        ylabel(conf.parNames{p},'interpreter','none',...
            'rotation',90,'horizontalalignment','right')
    end

    box on
    hold off
    if ~strcmp(plotMode,'figures')
        if p~=nPars(end)
            set(gca,'xticklabel',[])
        end
    end
end

xlabel('model evaluations')




if nargout==2
   varargout{1}=plotHandlesSequences;
   varargout{2}=plotHandlesGenerations;
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



function k = isodd(n)

k = mod(n,2)==1;

