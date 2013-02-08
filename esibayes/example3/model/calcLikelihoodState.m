function objScore = calcLikelihoodState(conf,constants,modelOutput,parVec)


% load('./data/lintank-obs.mat')
mmsodaUnpack()


iState = 1;
nPriors = 4;
nObs = nPriors-1;

sim = modelOutput(iState,1:nPriors);

ssr = sum((obs(1,2:nPriors)-sim(1,2:nPriors)).^2);



objScore = -(1/2) * nObs * log(ssr);


