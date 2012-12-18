


if ~isdeployed

    clear
    close all
    clc

    addpath('./../mmsoda')
    soda -docinstall
    addpath('./model')
    addpath('./data')
    addpath('./results')
    
    % make data
    load('./data/rastrigin_func_data.mat','o')
    mConstants = {'o',o};
    save('./data/constants.m.mat','mConstants')

    
    % makeconf
    N = 100;
    makeconf(N)
    
end


% run the SODA algorithm using the configuration variable 'conf'
[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda();


sodaSubplotScreen(1,1,1)
X = linspace(conf.parSpaceLoBound(1),conf.parSpaceHiBound(1),N);
Y = linspace(conf.parSpaceLoBound(2),conf.parSpaceHiBound(2),N);
hSurf=surf(X,Y,reshape(-evalResults(:,conf.objCol),[N,N]));
set(hSurf,'facealpha',0.75)
shading interp
hold on
[tmp,hCont]=contour3(X,Y,reshape(-evalResults(:,conf.objCol),[N,N]),20,'-k');
set(hCont,'linewidth',0.1)
view([25,40])
xlabel('x_1')
ylabel('x_2')
zlabel('-objScore')


% sodaSubplotScreen(1,1,1)
% X = linspace(conf.parSpaceLoBound(1),conf.parSpaceHiBound(1),N);
% Y = linspace(conf.parSpaceLoBound(2),conf.parSpaceHiBound(2),N);
% hSurf=surf(X,Y,reshape(-evalResults(:,conf.objCol),[N,N]).^1.1);
% set(hSurf,'facealpha',0.75)
% shading interp
% axis off
% hold on
% [tmp,hCont]=contour3(X,Y,reshape(-evalResults(:,conf.objCol),[N,N]).^1.1,20,'-k');
% set(hCont,'linewidth',0.1)
% view([25,40])
% xlabel('x_1')
% ylabel('x_2')
% zlabel('-objScore')
% 
% set(gcf,'paperpositionmode','auto','inverthardcopy','off')
% print(gcf,'-dpng','-r300','-loose','surface.png')
% 

