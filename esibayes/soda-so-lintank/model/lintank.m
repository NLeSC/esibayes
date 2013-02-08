function modelOutput = lintank(conf,constants,init,parVec,priorTimes)


mmsodaUnpack()


for iPrior=2:numel(priorTimes)
    
    
    

    timeNow = priorTimes(iPrior-1);

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

    stateValuesKFNew(1:conf.nStatesKF,iPrior) = simWaterLevel;
    valuesNOKFNew(1:conf.nNOKF,iPrior) = [rand;Q];
    
end


modelOutput = [stateValuesKFNew;valuesNOKFNew];