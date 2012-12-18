function makeconf()

% define what kind of run this will be ('bypass', 'scemua', 'reset' , or 'soda')
modeStr = 'bypass';
% define the objective function name
objCallStrs = {'objectivefun1','objectivefun2','objectivefun3'};
% define the name of the parameters for each parameter
parNames = {'theta1','theta2'};
% set the lower limit on the parameter space for each parameter
parSpaceLoBound = [0.0, 0.0];
% set the higher limit on the parameter space for each parameter
parSpaceHiBound = [1.0, 1.0];
% define the number of complexes
nCompl = 5;
% define the number of samples used for the burn-in
nSamples = 20*nCompl;
% define the maximum number of parameter space samples
nModelEvalsMax = nSamples+200*(1/5)*nSamples;
% specify if soda should visualize the results as they become available (requires X forwarding over ssh)
doPlot = true;
% specify how the parameter space is sampled ('stratified', 'stratified random'), useful for making imagescs of sensitivity
sampleDrawMode = 'stratified';
startFromUniform = true;
drawInterval = 10;
realPartOnly = true;


save('./results/conf.mat')

