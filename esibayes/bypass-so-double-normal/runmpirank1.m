


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
    
    % save the configuration to a mat file:
    makeconf()
    
end


% run the SODA algorithm using the configuration variable 'conf'
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();



sodaSubplotScreen(1,1,1)
sodaMargHist(conf,evalResults,'iterSelection',[conf.nSamples+1:size(evalResults,1)],'nBins',50,...
    'histMode','relative')
hold on
load('./data/obs.m.mat','obsX','obsDens')
plot(obsX,exp(obsDens),'-b')

