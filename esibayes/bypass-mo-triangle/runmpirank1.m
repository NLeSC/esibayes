


if ~isdeployed
    clear
    close all
    clc
    restoredefaultpath
    addpath('./../mmsoda')
    soda -docinstall
    addpath('./model')
    addpath('./data')
    addpath('./results')
end



% run the SODA algorithm
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();


sodaSubplotScreen(1,2,1)
plot(evalResults(:,conf.parCols(1)),evalResults(:,conf.parCols(2)),...
    'marker','o','markersize',6,'markerfacecolor',[0.75,0.75,0.75],...
    'markeredgecolor',[0.75,0.75,0.75],'linestyle','none')
hold on
plot(evalResults(end-999:end,conf.parCols(1)),evalResults(end-999:end,conf.parCols(2)),...
        'marker','o','markersize',6,'markerfacecolor',[1,0,0.5],...
        'markeredgecolor',[1,0,0.5],'linestyle','none')

sodaSubplotScreen(1,2,2)
sodaMatrixOfScatter(conf,'ll-ll',sequences,metropolisRejects,'nHistory','noinit')

