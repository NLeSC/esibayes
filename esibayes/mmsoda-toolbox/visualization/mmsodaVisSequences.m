function mmsodaVisSequences(conf,sequences,metropolisRejects)

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


error('deprecated')

evalCol = conf.evalCol;
parCols = conf.parCols;

nSequences = conf.nCompl;
nPars = conf.nOptPars;

nRowsSubplot = min([4,nPars]);
nColsSubplot = ceil(nPars/nRowsSubplot);


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


defaultColors = [0,0,1;...
    0,0.5,0;
    1,0,0;...
    1,0.5,0;...
    1,0.9,0;...
    0.5882,0.7216,0.1804;...
    0,1,1;...
    1,0,1;...
    0.7529,0.7529,0.7529;...
    0.1490,0.5333,0.7176];

nDefaultColors = size(defaultColors,1);

if nSequences>nDefaultColors
    cVec = linspace(0.1,0.9,ceil((nSequences-nDefaultColors)^(1/3)));
    extraColors = allcomb(cVec,cVec,cVec);
else
    extraColors=[];
end

dreamSeqColors =[defaultColors;extraColors];

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

set(gcf,'inverthardcopy','off',...
    'paperpositionmode','auto',...
    'numbertitle','off',...
    'name',['Sequences (',conf.modeStr,') - Figure ',num2str(gcf)])

clf

for iColSubplot = 1:nColsSubplot
    for iRowSubplot = 1:nRowsSubplot

        iPar = (iColSubplot-1)*nRowsSubplot+iRowSubplot;
        if iPar>nPars
            continue
        end

        iSubplot = (iRowSubplot-1)*nColsSubplot+iColSubplot;

        subplot(nRowsSubplot,nColsSubplot,iSubplot)
        for iSequence = 1:nSequences

            markerColor = dreamSeqColors(iSequence,1:3);
            if uimatlab || isdeployed
                plot(metropolisRejects(:,evalCol,iSequence),metropolisRejects(:,parCols(iPar),iSequence),...
                       'marker','s',...
                       'markersize',3,...
                       'linestyle','none',...
                       'markerfacecolor','none',...
                       'markeredgecolor',markerColor);
                hold on
                plot(sequences(:,evalCol,iSequence),sequences(:,parCols(iPar),iSequence),...
                       'marker','s',...
                       'markersize',3,...
                       'linestyle','none',...
                       'markerfacecolor',markerColor,...
                       'markeredgecolor',markerColor);
            elseif uioctave

                %rejColor = [0.3,0.3,0.3];
                plot(metropolisRejects(:,evalCol,iSequence),metropolisRejects(:,parCols(iPar),iSequence),...
                       'marker','s',...
                       'markersize',3,...
                       'linestyle','none',...
                       'markerfacecolor','none',...
                       'markeredgecolor',markerColor);
                hold on
                plot(sequences(:,evalCol,iSequence),sequences(:,parCols(iPar),iSequence),...
                       'marker','s',...
                       'markersize',3,...
                       'linestyle','none',...
                       'markerfacecolor',markerColor,...
                       'markeredgecolor',markerColor);
            else
            end
            hold on
        end

        set(gca,'ylim',[conf.parSpaceLoBound(iPar),conf.parSpaceHiBound(iPar)],...
            'color',[0.98,0.98,0.98])

        ylabel(conf.parNames{iPar},'interpreter','none')

        if iRowSubplot<nRowsSubplot & iPar<nPars
            set(gca,'xticklabel','')
        else
            xlabel('number of function evaluations')
        end
    end
end

