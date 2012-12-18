



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

    % define which variables are constants (i.e. for all parameter combinations, ensemble members, and data assimilation steps)
    mConstants = {'timeStep',1;...
                  'obsTime',obsTime;...
                  'obsQ',obsQ;...
                  'obsWaterLevel',obsWaterLevel;...
                  'modeStr','inv'};

    % save the constants variable in the data directory
    if uimatlab || isdeployed
        save('./data/constants.m.mat','-mat','mConstants')
    elseif uioctave
        save('./data/constants.m.mat','-mat7-binary','mConstants')
    else
    end
    

    % save config
    makeconf(obsTime,obsWaterLevel)
end






% run the SODA algorithm using the configuration variable 'conf'
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();


nSamplesPerGen = conf.nOffspringFraction*conf.nSamples;
iGen = (size(evalResults,1)-conf.nSamples)/nSamplesPerGen;
s = conf.nSamples+(iGen-1)*nSamplesPerGen+1;
e = conf.nSamples+iGen*nSamplesPerGen;
load(sprintf('./results/soda-results-enkf-evals-%d-%d.m.mat',s,e))
sodaSubplotScreen
sodaPlotEnsemble(conf,stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed)








