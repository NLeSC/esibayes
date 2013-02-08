function bundle = sodaProcessBundle(conf,constants,bundle)

nTasks = numel(bundle);
nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;
nDASteps = conf.nDASteps;

if strcmp(conf.modeStr,'scemua')
    nOutputs = conf.nOutputs;
end

switch bundle(1).type
    % a bundle of tasks has to be of the same type for this to work:
    case 'model'
        for iTask=1:nTasks
            stateValuesKFOld = bundle(iTask).stateValuesKFPost;
            valuesNOKFOld = bundle(iTask).valuesNOKF;
            parVec = bundle(iTask).parVec;
            priorTimes = bundle(iTask).priorTimes;
            nPrior = numel(priorTimes);
            
            init = cat(1,stateValuesKFOld,valuesNOKFOld);

            eval(['modelOutput = ',conf.modelName,'(conf,constants,init,parVec,priorTimes);'])
            
            switch conf.modeStr
                case {'reset','soda'}
                    bundle(iTask).stateValuesKFPrior(1:nStatesKF,1:nPrior) = modelOutput(1:nStatesKF,1:nPrior);
                    bundle(iTask).valuesNOKF(1:nNOKF,1:nPrior) = modelOutput(nStatesKF+(1:nNOKF),1:nPrior);
                case 'scemua'
                    % abuse the KFPrior field for storing the model
                    % outputs, even though we're not doing any KF:
                    bundle(iTask).stateValuesKFPrior(1:nOutputs,1:nPrior) = modelOutput(1:nOutputs,1:nPrior);
                    bundle(iTask).valuesNOKF(1:nNOKF,1:nPrior) = NaN;
                otherwise
            end
        end

    case 'objective'
        for iTask=1:nTasks

            if strcmp(conf.modeStr,'bypass')
                modelOutputs = [];
            else
                allStateValuesKFPrior = bundle(iTask).allStateValuesKFPrior;
                allValuesNOKF = bundle(iTask).allValuesNOKF;
                modelOutputs = cat(1,allStateValuesKFPrior,allValuesNOKF);
            end
            parVec = bundle(iTask).parVec;            

            if conf.isSingleObjective
                eval(['llScore = ',conf.objCallStr,'(conf,constants,modelOutputs,parVec);'])
                bundle(iTask).llScores = llScore;
            elseif conf.isMultiObjective
                for iObj = 1:conf.nObjs
                    eval(['llScores(1,iObj) = ',conf.objCallStrs{iObj},'(conf,constants,modelOutputs,parVec);'])
                end
                bundle(iTask).llScores = llScores;
            else
            end
        end
    otherwise
        % do nothing
end



