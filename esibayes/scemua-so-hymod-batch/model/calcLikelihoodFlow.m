function objScore = calcLikelihoodFlow(conf,constants,modelOutput,parVec)

mmsodaUnpack()

nPrior = conf.nPrior;

obs = dailyDischarge([iStart+wu:iEnd])';

sim = modelOutput(1,2:nPrior);

nObs = nPrior-1;

objScore = -(1/2) * nObs * log(sum((obs-sim).^2));
