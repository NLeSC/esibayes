function makeconf()




modeStr = 'scemua';
modelName = 'hymod_batch'
objCallStr = 'calcLikelihood';
parNames = {'cmax','bexp','fQuickFlow','Rs','Rq'};
parSpaceHiBound = %;
parSpaceLoBound = %;
priorTimes = %

save('./results/conf.mat')