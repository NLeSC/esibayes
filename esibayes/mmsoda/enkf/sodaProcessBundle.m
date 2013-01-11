function bundle = sodaProcessBundle(conf,constants,bundle)

nTasks = numel(bundle);
nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;
nDASteps = conf.nDASteps;


switch bundle(1).type
    % a bundle of tasks has to be of the same type for this to work:
    case 'model'
        for iTask=1:nTasks
            stateValuesKFOld = bundle(iTask).stateValuesKFPost;
            valuesNOKFOld = bundle(iTask).valuesNOKF;
            parVec = bundle(iTask).parVec;
            priorTimes = bundle(iTask).priorTimes;
            nPrior = numel(priorTimes);

            eval(['[stateValuesKFNew,valuesNOKFNew] = ',conf.modelName,'(conf,constants,stateValuesKFOld,valuesNOKFOld,parVec,priorTimes);'])

            switch conf.modeStr
                case {'reset','soda'}
                    % bundle(iTask).stateValuesKFPrior(1:nStatesKF,2:nPrior) = stateValuesKFNew(1:nStatesKF,1:nPrior-1);
                    % bundle(iTask).valuesNOKF(1:nNOKF,2:nPrior) = valuesNOKFNew(1:nNOKF,1:nPrior-1);
                    bundle(iTask).stateValuesKFPrior(1:nStatesKF,1:nPrior) = stateValuesKFNew(1:nStatesKF,1:nPrior);
                    bundle(iTask).valuesNOKF(1:nNOKF,1:nPrior) = valuesNOKFNew(1:nNOKF,1:nPrior);
                case 'scemua'
                    % bundle(iTask).stateValuesKFPrior(1:nStatesKF,2:nPrior) = stateValuesKFNew(1:nStatesKF,1:nPrior-1);
                    % bundle(iTask).valuesNOKF(1:nNOKF,2:nPrior) = valuesNOKFNew(1:nNOKF,1:nPrior-1);
                    bundle(iTask).stateValuesKFPrior(1:nStatesKF,1:nPrior) = stateValuesKFNew(1:nStatesKF,1:nPrior);
                    bundle(iTask).valuesNOKF(1:nNOKF,1:nPrior) = valuesNOKFNew(1:nNOKF,1:nPrior);
                otherwise
            end
        end

    case 'objective'
        for iTask=1:nTasks

            allStateValuesKFPrior = bundle(iTask).allStateValuesKFPrior;
            allValuesNOKF = bundle(iTask).allValuesNOKF;
            parVec = bundle(iTask).parVec;

            if conf.isSingleObjective
                eval(['llScore = ',conf.objCallStr,'(conf,constants,allStateValuesKFPrior,allValuesNOKF,parVec);'])
                bundle(iTask).llScores = llScore;
            elseif conf.isMultiObjective
                for iObj = 1:conf.nObjs
                    eval(['llScores(1,iObj) = ',conf.objCallStrs{iObj},'(conf,constants,allStateValuesKFPrior,allValuesNOKF,parVec);'])
                end
                bundle(iTask).llScores = llScores;
            else
            end
        end
    otherwise
        % do nothing
end



