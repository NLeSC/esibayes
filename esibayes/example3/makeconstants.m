function makeconstants()


load('./data/lintank-obs.mat','obsTimes','obs')


% initialize the value of the upper tank
state1Init = 30.0;
% initialize the value of the lower tank
state2Init = 0;

% set the default model integration step
dtSimDefault = 30.5;

save('./data/constants.mat')