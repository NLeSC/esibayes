


if ~isdeployed
    clear
    close all
    clc

    addpath('./../mmsoda')
    soda -docinstall
    addpath('./model')
    addpath('./data')
    addpath('./results')
    
    % create the artificial data
    disp('running ''makedata.m'' to generate the artificial data...')
    makedata()

    % load the observations that were just created by 'makedata'
    load('./data/obs.m.mat','obsWaterLevel','obsTime','obsQ','timeStep')
    simTime = obsTime;

    % save the soda config
    makeconf(obsTime,obsWaterLevel)    
    
end




% run the SODA algorithm using the configuration variable 'conf'
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();

load(['./results/',conf.modeStr,'-results-enkf-evals-1041-1050.m.mat'])
nParsets = size(stateValuesKFPrior,1);
nMembers = conf.nMembers;
nDASteps = conf.nDASteps;
iStateKF = 1;
greyish = 0.80*[1,1,1];
visMember = 1;
vecMembers = [1:conf.nMembers];

for iParset = nParsets%1:nParsets
    sodaSubplotScreen(1,1,1)
    switch conf.modeStr
        case 'soda'
            for iMember = 1:numel(vecMembers)
                if vecMembers(iMember)~=visMember
                    w = 0.45*find(iMember==(1:numel(vecMembers)))/numel(vecMembers);
                    sodaPlotEnsemble(conf,stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed,...
                        'iMember',vecMembers(iMember),'iParset',iParset,'iStateKF',iStateKF,...
                        'colorObs',greyish,'colorSim',greyish,'colorPost',greyish);
                    hold on
                end
            end
            w = 0.45*find(visMember==vecMembers)/numel(vecMembers);
            hObs = plot(obsTime,obsWaterLevel,'ob','markersize',6,'markerfacecolor','b','markeredgecolor','b');
            handles = sodaPlotEnsemble(conf,stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed,...
                'iMember',visMember,'iParset',iParset,'iStateKF',iStateKF,'connStyle',{'linewidth',2.0});
            legend([hObs;handles.obs(1);handles.obsPert(1);handles.statesPrior(1);...
                handles.statesPert(1);handles.statesPost(1)],...
                'obs,all','obs,DA','obs,pert','sim,prior','sim,pert','posterior')
        case 'reset'
                w = 0.45;
                hObs = plot(obsTime,obsWaterLevel,'ob','markersize',6,'markerfacecolor','b','markeredgecolor','b');
                handles = sodaPlotEnsemble(conf,stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed,...
                    'iMember',visMember,'iParset',iParset,'iStateKF',iStateKF);
                legend([hObs;handles.obs(1);handles.statesPrior(1);...
                    handles.statesPost(1)],...
                    'obs,all','obs,da','sim,prior','posterior')
        otherwise
    end
    xlabel('time')
    ylabel('state')
    title([upper(conf.modeStr),' iEval = ',...
        num2str(parsets(iParset,conf.evalCol)),...
        '; iMember = ',num2str(visMember),...
        '; parameter value = ',num2str(parsets(iParset,conf.parCols))])
    set(gca,'xlim',conf.priorTimes([1,end]),'ylim',[28,47])
end



% set(gcf,'color',[1,0,0])
% 
% set(gcf,'paperpositionmode','auto','inverthardcopy','off')
% print(gcf,'-depsc2','-r200','-loose','ensemble')




