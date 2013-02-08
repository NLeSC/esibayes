function makeconf()


modeStr = 'scemua';
modelName = 'lintank';
objCallStr = 'calcLikelihoodState';
parNames = {'R'};
parSpaceHiBound = 1000;
parSpaceLoBound = 80;
priorTimes = [0,61,147,200];
nOutputs = 2;


saveInterval = 0;
drawInterval = 50;

doPlot = false
nSamples = 100;

nModelEvalsMax = 2000;

save('./results/conf.mat')
