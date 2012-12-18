


if ~isdeployed

    clear
    close all
    clc

    addpath('./../mmsoda')
    soda -docinstall
    addpath('./model')
    addpath('./data')
    addpath('./results')
    
    
    load('./data/rosenbrock_func_data.mat','o')
    mConstants = {'o',o};

    save('./data/constants.m.mat','mConstants')

    makeRespSurf = true
    
    % save the configuration file
    makeconf(makeRespSurf)
    
    
end




% run the SODA algorithm using the configuration variable 'conf'
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();

if makeRespSurf
    sodaSubplotScreen(1,1,1)
    X = linspace(conf.parSpaceLoBound(1),conf.parSpaceHiBound(1),100);
    Y = linspace(conf.parSpaceLoBound(2),conf.parSpaceHiBound(2),100);
    surf(X,Y,log10(reshape(-evalResults(:,conf.objCol),[100,100])))
    shading flat
    view([30,50])
    xlabel('x_1')
    ylabel('x_2')
    zlabel('log10(-objScore)')
end


