function [stateValuesKFNew,valuesNOKFNew] = lintank(conf,mConstants,stateValuesKFOld,valuesNOKFOld,parVec,timeVecPrior)


nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;
nPriorChunk = numel(timeVecPrior);

stateValuesKFNew = repmat(NaN,[nStatesKF,nPriorChunk]);
valuesNOKFNew = repmat(NaN,[nNOKF,nPriorChunk]);

if any(strcmp(conf.modeStr,{'soda','reset'}))
    % map the KF states values to their respective variables:
    simWaterLevel = stateValuesKFOld(1,1);
end
% map the constants values to their respective variables:
for iConstant=1:size(mConstants,1)
    eval([mConstants{iConstant,1},'=mConstants{iConstant,2};'])
end
% map the parameter values to their respective variables:
R = parVec(1);


for iPrior=2:nPriorChunk

    timeNow = timeVecPrior(iPrior-1);

    if timeNow==conf.priorTimes(1)
        if strcmp(conf.modeStr,'scemua')
            simWaterLevel = simWaterLevelInit;
        end
    end


    switch modeStr
        case 'fwd'
            if timeNow == 20
                simWaterLevel = simWaterLevel *1.30;
            end
        case 'inv'
        otherwise
    end
    

    Q = simWaterLevel*-(1/R);
    simWaterLevel = simWaterLevel + Q*timeStep;

    stateValuesKFNew(1:nStatesKF,iPrior) = simWaterLevel;
    valuesNOKFNew(1:nNOKF,iPrior) = [rand;Q];
    
end
