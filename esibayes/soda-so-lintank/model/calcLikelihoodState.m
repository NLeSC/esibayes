function objScore = calcLikelihoodState(conf,constants,modelOutput,parVec)

sodaUnpack()


[nOutputs,nDASteps,nMembers,tmp] = size(modelOutput);

% row of interest in modelOutput is #1
r = 1;

obs = repmat(obsWaterLevel(2:nDASteps),[1,1,nMembers]);
sim = modelOutput(r,2:nDASteps,1:nMembers);

nObs = nDASteps-1;

ensembleMeanErr = mean(obs-sim,3);

ssr = sum(ensembleMeanErr.^2);

objScore = -(1/2) * nObs * log(ssr);