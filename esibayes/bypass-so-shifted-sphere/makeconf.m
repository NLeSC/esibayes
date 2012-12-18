function makeconf(N)

% define the objective function name
objCallStr = 'shiftedSphere';
% define the name of the parameters for each parameter
parNames = {'x1','x2'};
% set the lower limit on the parameter space for each parameter
parSpaceLoBound = [-100,-100];
% set the higher limit on the parameter space for each parameter
parSpaceHiBound = [100,100];
% define what kind of run this will be ('bypass', 'scemua', 'reset', or 'soda')
modeStr = 'bypass';
% define the number of complexes
nCompl = 5;
% specify if soda should visualize the results as they become available (requires X forwarding over ssh)
doPlot = true;
% specify how the parameter space is sampled ('stratified', 'stratified random'), useful for making imagescs of sensitivity
sampleDrawMode = 'stratified';
% define the number of samples used for the burn-in
nSamples = N*N;
% define the maximum number of parameter space samples
nModelEvalsMax = nSamples;

clear N

save('./results/conf.mat')

