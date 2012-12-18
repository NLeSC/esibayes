


if ~isdeployed
    clear
    close all
    clc

    addpath('./../mmsoda')
    soda -docinstall
    addpath('./model')
    addpath('./data')
    addpath('./results')
    
    
    makedata()

    clear

    % load the artificial data
    load('./data/leafriver-art.m.mat','numTime','dailyDischarge',...
        'dailyPotEvapTrans','dailyPrecip','wu','iStart','iEnd','convFactor',...
        'obsQSigma')

    sodaPack
    save('./data/constants.m.mat','mConstants')

    % save configuration
    makeconf(iStart,iEnd,wu,numTime,dailyDischarge)
    
    
end





% run the SODA algorithm using the configuration variable 'conf'
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();

sodaSubplotScreen(1,1,1)

nGen = (size(evalResults,1)-conf.nSamples)/(conf.nSamples*1/5);
M=[];
for iGen=nGen-9:nGen
    iEvalStart = conf.nSamples + (iGen-1)*(conf.nSamples*1/5)+1;
    iEvalEnd = conf.nSamples + iGen*conf.nOffspring;
    load(sprintf('./results/%s-results-enkf-evals-%d-%d.m.mat',conf.modeStr,iEvalStart,iEvalEnd))
    M = [M;squeeze(valuesNOKF(:,1,1,:))];
end

ySim = prctile(M,[2.5,50.0,97.5],1);

handles = plot(conf.priorTimes-conf.priorTimes(1),ySim,'-b');
set(handles(2),'color','r')
hold on
hObs = plot(conf.priorTimes-conf.priorTimes(1),dailyDischarge([iStart,iStart+wu:iEnd]),'ob','markersize',3,'markerfacecolor','b','markeredgecolor','b');

legend([hObs;handles(1);handles(2)],'obs,all','sim,95% interval','sim,median')
xlabel('time')
ylabel('flow [m3/s]')
title(upper(conf.modeStr))
% set(gca,'xlim',conf.priorTimes([1,end])-conf.priorTimes(1))
    




