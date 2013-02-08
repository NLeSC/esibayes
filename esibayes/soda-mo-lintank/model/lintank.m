function modelOutput  = lintank(conf,constants,init,parVec,priorTimes)

mmsodaUnpack()

nPriorChunk = numel(priorTimes);
nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;

for k=2:nPriorChunk

    timeNow = priorTimes(k-1);
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

    stateValuesKFNew(1:nStatesKF,k) = simWaterLevel;
    valuesNOKFNew(1:nNOKF,k) = [rand;Q];
    
end



modelOutput = [stateValuesKFNew;valuesNOKFNew];