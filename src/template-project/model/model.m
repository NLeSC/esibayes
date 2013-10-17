function modelOutput = <modelname>(conf,constants,init,parVec,priorTimes)
mmsodaUnpack()
% first lines are always the same

% directly go to the dynamic part of the model,
% iterate over the elements of variables 'priorTimes'
% this is the main body of the model file.

% after the dynamic part, there needs to be an array modelOutput of size 
% nOutput x nPrior for modeStr=='scemua' or of size (nStatesKF + nNOKF) 
% x nPrior for 'reset' and 'soda' modes.