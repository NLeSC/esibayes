function mmsodaPlotGelmanRubin(conf,critGelRub,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPlotGelmanRubin.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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

