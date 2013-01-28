function makeconf()

modeStr = 'bypass';
objCallStr = 'calcLikelihood';
parNames = {'x'};
parSpaceHiBound = [30];
parSpaceLoBound = [-10];

save('./results/conf.mat')
