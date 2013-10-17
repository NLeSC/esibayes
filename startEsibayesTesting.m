

% restoredefaultpath
% 
% clear
% close all
% clc

addpath(fullfile(pwd,'src'))


try
    addpath(fullfile(pwd,'testing','xunit','xunit'))
    
    profile on

    runtests testing/ -xmlfile testreport.xml
    
    profsave(profile('info'),'profiler-results')
    
catch Ex
    fprintf(2, Ex.getReport())
    quit(1)
end
quit(0)

