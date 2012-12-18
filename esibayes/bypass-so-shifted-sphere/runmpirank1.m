


if ~isdeployed

    clear
    close all
    clc

    addpath('./../mmsoda')
    soda -docinstall
    addpath('./model')
    addpath('./data')
    addpath('./results')
    

    load('shifted-sphere.mat','o')
    mConstants = {'o',o};

    save('./data/constants.m.mat','mConstants')
    
    % make configuration:
    N = 100;
    makeconf(N)
    
end





% run the SODA algorithm using the configuration variable 'conf'
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();


sodaSubplotScreen(1,1,1)
imagesc(reshape(evalResults(:,conf.objCol),[N,N]))

