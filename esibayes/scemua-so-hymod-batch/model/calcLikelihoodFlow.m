function objScore = calcLikelihoodFlow(conf,constants,modelOutputs,parVec)

sodaUnpack()

nPrior = conf.nPrior;

obs = dailyDischarge([iStart+wu:iEnd])';

sim = modelOutputs(1,2:nPrior);

nObs = nPrior-1;

objScore = -(1/2) * nObs * log(sum((obs-sim).^2));
