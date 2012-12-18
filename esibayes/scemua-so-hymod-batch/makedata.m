



load('./data/leafriver.mat','numTime','dailyDischarge','dailyPotEvapTrans','dailyPrecip')

wu = 65;
iStart = 1;
iEnd = iStart + wu - 1 + 730;
convFactor = 22.5;

% crudest estimate of sigma ever:
obsQSigma = 0.01;%std(dailyDischarge(1:end-1)-dailyDischarge(2:end));

sodaPack()


conf.nOptPars = 5;
conf.parNames = {'cmax','bexp','fQuickFlow','Rs','Rq'};
conf.nStatesKF = 0;
conf.nNOKF = 1;
conf.namesNOKF = {'output'};
conf.priorTimes = numTime([iStart,iStart+wu:iEnd]);

stateValuesKFOld = [];

valuesNOKFOld = NaN;

parVec=[300,0.2,0.3,0.01,0.4];

priorTimes = conf.priorTimes';


[stateValuesKFNew,valuesNOKFNew] = hymod_batch(conf,mConstants,...
                stateValuesKFOld,valuesNOKFOld,parVec,priorTimes);

nPrior = numel(priorTimes);

dailyDischarge = repmat(NaN,size(dailyDischarge));
dailyDischarge(iStart+wu:iEnd) = valuesNOKFNew(2:nPrior);


save('./data/leafriver-art.m.mat','dailyDischarge','dailyPotEvapTrans',...
'dailyPrecip','iStart','iEnd','numTime','parVec','priorTimes','conf',...
'stateValuesKFNew','stateValuesKFOld','valuesNOKFNew','valuesNOKFOld',...
'wu','convFactor','obsQSigma')
























