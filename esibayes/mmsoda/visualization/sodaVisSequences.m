function sodaVisSequences(sodaPar,sequences,metropolisRejects)

evalCol = sodaPar.evalCol;
parCols = sodaPar.parCols;

nSequences = sodaPar.nCompl;
nPars = sodaPar.nOptPars;

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
    'name',['Sequences (',sodaPar.modeStr,') - Figure ',num2str(gcf)])

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

        set(gca,'ylim',[sodaPar.parSpaceLoBound(iPar),sodaPar.parSpaceHiBound(iPar)],...
            'color',[0.98,0.98,0.98])

        ylabel(sodaPar.parNames{iPar},'interpreter','none')

        if iRowSubplot<nRowsSubplot & iPar<nPars
            set(gca,'xticklabel','')
        else
            xlabel('number of function evaluations')
        end
    end
end

