

% restoredefaultpath
% 
% clear
% close all
% clc

addpath(fullfile(pwd,'src'))


try
    addpath(fullfile(pwd,'testing','xunit','xunit'))
    runtests testing/ -xmlfile testreport.xml
catch Ex
    fprintf(2, Ex.getReport())
    quit(1)
end
quit(0)

