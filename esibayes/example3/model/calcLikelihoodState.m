function objScore = calcLikelihoodState(conf,constants,modelOutputs,parVec)


% load('./data/lintank-obs.mat')
sodaUnpack()


iState = 1;
nPriors = 4;
nObs = nPriors-1;

sim = modelOutputs(iState,1:nPriors);

ssr = sum((obs(1,2:nPriors)-sim(1,2:nPriors)).^2);



objScore = -(1/2) * nObs * log(ssr);


