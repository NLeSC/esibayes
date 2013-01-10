

calledByModel__ =  exist('priorTimes','var')==1;

if calledByModel__
    
    nStatesKF = conf.nStatesKF;
    nNOKF = conf.nNOKF;
    nPriorChunk = numel(priorTimes);

    % prepare the output arrays with NaNs
    stateValuesKFNew = repmat(NaN,[nStatesKF,nPriorChunk]);
    valuesNOKFNew = repmat(NaN,[nNOKF,nPriorChunk]);
    clear nPriorChunk


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

end
clear calledByModel__

% map the parameter values to their respective variables:
for iPar = 1:conf.nOptPars
    eval([conf.parNames{iPar},' = parVec(iPar);'])
end
clear iPar

% map the constants values to their respective variables:
FN__ = fieldnames(constants);
for iConstant__ = 1:size(FN__,1)
    eval([FN__{iConstant__},' = constants.',FN__{iConstant__},';'])
end


clear iConstant__
clear FN__


