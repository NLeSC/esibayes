function makedata()

constants = load('./data/constants.mat');
conf = load('./results/conf.mat')

obsX = -20:0.1:20;
obsDens = repmat(NaN,size(obsX));
for k=1:numel(obsX)

    parVec = obsX(k);
    obsDens(k) = calcLikelihood(conf,constants,[],[],parVec);

end

figure
plot(obsX,exp(obsDens),'-b')


save('./data/obs.mat','-mat','obsX','obsDens')




