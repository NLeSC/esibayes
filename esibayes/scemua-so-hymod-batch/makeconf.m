function makeconf()



load('./data/constants.mat')




% define what kind of run this will be ('bypass', 'scemua', 'reset' , or 'soda')
modeStr = 'scemua';
% define the model name
modelName = 'hymod_batch';
% define the objective function name
objCallStr = 'calcLikelihoodFlow';
% define the name of the parameters for each parameter
parNames = {'cmax','bexp','fQuickFlow','Rs','Rq'};
% set the lower limit on the parameter space for each parameter
parSpaceLoBound = [200.0, 0.1, 0.00, 0.001, 0.200];  % lower limits on the parameter space
% set the higher limit on the parameter space for each parameter
parSpaceHiBound = [350.0, 0.6, 0.99, 0.02, 0.600];   % upper limits on the parameter space
% define the names of additional variables that are unique to each member
% namesNOKF = {'output'};
nOutputs = 1;
% define the variable that contains the time steps for which data assimilation will be performed
priorTimes = numTime([iStart,iStart+wu:iEnd]);
% define the number of complexes
nCompl = 5;
% define the number of samples used for the burn-in
nSamples = 20*nCompl;
% define the maximum number of parameter space samples
% nModelEvalsMax = nSamples+50*(1/5)*nSamples;
% define the number of ensemble members to use in the EnKF
nMembers = 1;
% specify if soda should visualize the results as they become available (requires X forwarding over ssh)
doPlot = false;
% specify how the parameter space is sampled ('stratified', 'stratified random'), useful for making imagescs of sensitivity
sampleDrawMode = 'stratified';
startFromUniform = true;
drawInterval = 10;
realPartOnly = true;
saveInterval = 0; %dont' save for performance
saveEnKFResults = false % not used in scemua but whatever

visualizationCall = 'mmsodaVisualization5';

if doPlot
   figure
   plot(priorTimes,dailyDischarge([iStart,iStart+wu:iEnd]),'-mo')
   set(gca,'xlim',[priorTimes(1),priorTimes(end)],'ylim',[0,max(dailyDischarge*1.1)])
   drawnow
end



clear iStart
clear iEnd
clear wu
clear numTime
clear dailyDischarge
clear dailyPotEvapTrans
clear dailyPrecip
clear convFactor
clear obsQSigma


save('./results/conf.mat')

