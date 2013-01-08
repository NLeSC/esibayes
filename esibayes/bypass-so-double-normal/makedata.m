function makedata()

addpath('./model')

parMu1 = -10;
parSigma1 = 3;
parMu2 = 5;
parSigma2 = 1;

mConstants = {'parMu1',parMu1;'parSigma1',parSigma1;'parMu2',parMu2;'parSigma2',parSigma2};

obsX = -20:0.1:20;
obsDens = repmat(NaN,size(obsX));
for k=1:numel(obsX)

    parVec = obsX(k);
    obsDens(k) = calcLikelihood(mConstants,[],[],parVec);

end

figure
plot(obsX,exp(obsDens),'-b')



save('./data/obs.m.mat','-mat','obsX','obsDens')
save('./data/constants.m.mat','-mat','mConstants')




