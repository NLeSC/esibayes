function [stateValuesKFNew,valuesNOKFNew] = lintank(conf,constants,stateValuesKFOld,valuesNOKFOld,parVec,priorTimes)
sodaUnpack()
% first lines are always the same

% directly go to the dynamic part of the model,
% iterate over the elements of variables 'priorTimes'
% this is the main body of the model file.

% after the dynamic part the variables of interest are 'stateValuesKFNew' and 
% 'valuesNOKFNew'. The former contains the prior predictions of the states,
% while the latter contains the values of other variables that are eitehr unique to
% the ensemble member (reset and soda modes) or need to be passed on to the objective 
% function (typical example would be a system output).
