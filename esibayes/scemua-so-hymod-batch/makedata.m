function makedata()


load('./data/leafriver.mat','numTime','dailyDischarge','dailyPotEvapTrans','dailyPrecip')

wu = 65;
iStart = 1;
iEnd = iStart + wu - 1 + 730;
convFactor = 22.5;

% crudest estimate of sigma ever:
obsQSigma = 0.01;%std(dailyDischarge(1:end-1)-dailyDischarge(2:end));



% fake conf variable:
conf.nOptPars = 5;
conf.parNames = {'cmax','bexp','fQuickFlow','Rs','Rq'};
conf.nStatesKF = 0;
conf.nNOKF = 0;
% conf.namesNOKF = {'output'};
conf.nOutputs = 1;
conf.priorTimes = numTime([iStart,iStart+wu:iEnd]);
conf.modeStr = 'scemua';

% fake constants variable:
constants.wu = wu;
constants.iStart = iStart;
constants.iEnd = iEnd;
constants.convFactor = convFactor;
constants.obsQSigma = obsQSigma;
constants.numTime = numTime;
constants.dailyDischarge = dailyDischarge;
constants.dailyPotEvapTrans =dailyPotEvapTrans;
constants.dailyPrecip = dailyPrecip;



init = [[];NaN];

parVec=[300,0.2,0.3,0.01,0.4];

priorTimes = conf.priorTimes';


modelOutput = hymod_batch(conf,constants,init,parVec,priorTimes);

nPrior = numel(priorTimes);

dailyDischarge = repmat(NaN,size(dailyDischarge));
dailyDischarge(iStart+wu:iEnd) = modelOutput(1,2:nPrior);


save('./data/leafriver-art.mat','dailyDischarge','dailyPotEvapTrans',...
'dailyPrecip','iStart','iEnd','numTime','parVec','priorTimes','conf',...
'modelOutput','init','wu','convFactor','obsQSigma')
























