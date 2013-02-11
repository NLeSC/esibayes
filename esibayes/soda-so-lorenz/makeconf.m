function makeconf()


load('./data/obs.mat','obsState')

covModelPert = eye(3)*2.0; 
covObsPert = eye(3)*2.0;
initMethodKF = 'reference';
initValuesKF = [1.508870;-1.531271;25.46091];
modeStr = 'soda';
modelName = 'lorenzeq';
objCallStr = 'calcLikelihood'
obsState = obsState;
parNames = {'parSigma','parBeta','parRho'};
parSpaceHiBound = [30,10,50];
parSpaceLoBound = [0,0,0];
priorTimes = [0.00:0.25:40.0]   % was 40.0
stateNamesKF = {'u(1,1)','u(2,1)','u(3,1)'};
stateSpaceHiBound = [ 50, 50, 50];
stateSpaceLoBound = [-50,-50,-50];

nCompl = 5;
nSamples = 50;
nModelEvalsMax = 5000;
walltime = 55/60/24;  
nMembers = 5*3+1;  % rule of thumb: 5 times the number of states plus one
doPlot = false
drawInterval = 0
startFromUniform = false;
saveInterval = 1;

save('./results/conf.mat')

% initMethodNOKF
% initValuesNOKF
% namesNOKF
