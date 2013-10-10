% load the MMSODA configuration and the 'evalResults' array
load('./results/scemua-so-results.mat','conf','evalResults')

% load the model constants from the data subdirectory
constants = load('./data/constants.mat');

% set the initial state to empty for scemua run (nStatesKF = 0);
init = [];

% define the number of model outputs to include in the construction of the
% parameter uncertainty intervals:
nIntervals = 250;

% count the number of rows in 'evalResults'
nRows = size(evalResults,1);

% pre-allocate the array that will hold the model outputs
allModelOutputs = repmat(NaN,[nIntervals,conf.nPrior]);

% iterate over the last 'nIntervals' rows in 'evalResults', retrieve the
% parameter set, re-run the model structure, and store the model output
for k = nRows+(-nIntervals+1:1:0)

    % retrieve the k-th parameter set
    parVec = evalResults(k,conf.parCols);

    % % re-run the model with the k-th parameter set
    modelOutput = lintank(conf,constants,init,parVec,conf.priorTimes);

    % store the model output
    allModelOutputs(k+nIntervals-nRows,1:conf.nPrior) = modelOutput;

end
% calculate the 2.5, 50, and 97.5 percent parameter uncertainty percentiles
% using MMSODA's 'mmsodaPrctile' function:
percentiles = mmsodaPrctile(allModelOutputs,[2.5,50,97.5]);

% retrieve a list of unique parameter combinations that have the best
% objective scores using MMSODA's 'mmsodaBestParsets' function
bestsets = mmsodaBestParsets(conf,evalResults,'unique');

% pre-allocate the array that holds the model outputs associated with the
% best objective scores
bestModelOutputs = repmat(NaN,[size(bestsets,1),conf.nPrior]);

% use the same principle as before to iterate over the rows in the list of
% best parameter sets, re-run the model, and store the output
for k = 1:size(bestsets,1)

    parVec = bestsets(k,1:conf.nOptPars);
    modelOutput = lintank(conf,constants,init,parVec,conf.priorTimes);
    bestModelOutputs(k,1:conf.nPrior) = modelOutput;

end

% plot the observations along with the 2.5% parameter uncertainty
% percentile, the median, the 97.5% parameter uncertainty percentile, and
% the best model output associated with the best parameter combination
figure
h = plot(constants.obsTimes,constants.obs,'om-',...
    conf.priorTimes,percentiles(1,1:conf.nPrior),'--k',...
    conf.priorTimes,percentiles(2,1:conf.nPrior),'-k',...
    conf.priorTimes,percentiles(3,1:conf.nPrior),'--k',...
    conf.priorTimes,bestModelOutputs,'-b.');
xlabel('Time')
ylabel('State')
legend([h([1,2,3,5])],'obs','95% parameter uncetainty interval','median','best sim')
