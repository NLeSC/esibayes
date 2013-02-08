function makeconf()

modeStr = 'bypass';
objCallStr = 'calcLikelihood';
parNames = {'x'};
parSpaceHiBound = [10];
parSpaceLoBound = [-30];
doPlot=true
visualizationCall='mmsodaVisualization4'

save('./results/conf.mat')