function objScore = rmse_flow(conf,constants,modelOutput,parVec)

mmsodaUnpack()


[nOutputs,nDASteps,nMembers,tmp] = size(modelOutput);

% row of interest in modelOutput is #3
r = 3;

obs = repmat(obsQ(2:nDASteps),[1,1,nMembers]);
sim = modelOutput(r,2:nDASteps,1:nMembers);

nObs = nDASteps-1;

ensembleMeanErr = mean(obs-sim,3);

ssr = sum(ensembleMeanErr.^2);

objScore = (1/2) * nObs * log(ssr);