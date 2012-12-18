


nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;
nPriorChunk = numel(priorTimes);

% prepare the output arrays with NaNs
stateValuesKFNew = repmat(NaN,[nStatesKF,nPriorChunk]);
valuesNOKFNew = repmat(NaN,[nNOKF,nPriorChunk]);


% map the KF state values to their respective variables
for iStateKF = 1:nStatesKF
    eval([conf.stateNamesKF{iStateKF},' = stateValuesKFOld(iStateKF,1);'])
end
clear iStateKF
clear nStatesKF


% map the non-KF valuies to their respective variables
for iNOKF = 1:nNOKF
    eval([conf.namesNOKF{iNOKF},' = valuesNOKFOld(iNOKF,1);'])
end
clear iNOKF
clear nNOKF


% map the parameter values to their respective variables:
for iPar = 1:conf.nOptPars
    eval([conf.parNames{iPar},' = parVec(iPar);'])
end
clear iPar

% map the constants values to their respective variables:
for iConstant = 1:size(mConstants,1)
    eval([mConstants{iConstant,1},' = mConstants{iConstant,2};'])
end

clear iConstant
clear nPriorChunk



