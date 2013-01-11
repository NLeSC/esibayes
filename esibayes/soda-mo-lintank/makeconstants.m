function makeconstants()

% load the observations that were just created by 'makedata'
load('./data/obs.mat','obsWaterLevel','obsTime','obsQ','timeStep')
simTime = obsTime;

% define which variables are constants (i.e. for all parameter combinations, ensemble members, and data assimilation steps)
timeStep = 1;
modeStr = 'inv';
          
save('./data/constants.mat')





