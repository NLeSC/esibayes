function objScore = calcLikelihood(conf,constants,modelOutput,parVec)

mmsodaUnpack()

nStatesKF = conf.nStatesKF;
nPrior = conf.nPrior;
nMembers = conf.nMembers;
nObs = (conf.nPrior-1) * conf.nStatesKF;

obs = repmat(obsState(1:nStatesKF,2:nPrior),[1,1,nMembers]);
sim = modelOutput(1:nStatesKF,2:nPrior,1:nMembers);

ensembleMeanErr = mean(obs-sim,3);


ssr = sum(ensembleMeanErr(:).^2);

objScore = -(1/2) * nObs * log(ssr);



