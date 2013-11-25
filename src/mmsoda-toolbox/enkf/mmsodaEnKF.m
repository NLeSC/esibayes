function parsets = mmsodaEnKF(conf,parsets)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaEnKF.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% % 

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END


if conf.executeInParallel
    if ~(exist('verbosity','var')==1)
        getverbosity();
    end
end

evalCol = conf.evalCol;
parCols = conf.parCols;
nWorkers = conf.nWorkers;
nParSets = size(parsets,1);
nMembers = conf.nMembers;
nPrior = conf.nPrior;
nDASteps = conf.nDASteps;


emptyCellModelBundle = cell(ceil((nParSets*nMembers)/nWorkers),1);
emptyCellObjectiveBundle = cell(ceil(nParSets/nWorkers),1);


if strcmp(conf.modeStr,'bypass')
    
elseif strcmp(conf.modeStr,'scemua')

    nOutputs = conf.nOutputs;
    
    nanArrayModelOutputs = repmat(NaN,[nParSets,nMembers,nOutputs,nPrior]);
    
    modelBundleTemplate = struct('type',emptyCellModelBundle,...
                                 'iEval',emptyCellModelBundle,...
                                 'iParSet',emptyCellModelBundle,...
                                 'iMember',emptyCellModelBundle,...
                                 'parVec',emptyCellModelBundle,...
                                 'modelOutput',emptyCellModelBundle,...
                                 'priorTimes',emptyCellModelBundle);

elseif strcmp(conf.modeStr,'reset')

    nStatesKF = conf.nStatesKF;
    nNOKF = conf.nNOKF;
    
    nanArrayKF = repmat(NaN,[nParSets,nMembers,nStatesKF,nPrior]);
    nanArrayNOKF = repmat(NaN,[nParSets,nMembers,nNOKF,nPrior]);
    
    stateValuesKFPrior = nanArrayKF;
    valuesNOKF = nanArrayNOKF;
    stateValuesKFPost = nanArrayKF;
    stateValuesKFInn = nanArrayKF;
    
    modelBundleTemplate = struct('type',emptyCellModelBundle,...
                             'iEval',emptyCellModelBundle,...
                             'iParSet',emptyCellModelBundle,...
                             'iMember',emptyCellModelBundle,...
                             'iDAStep',emptyCellModelBundle,...
                             'parVec',emptyCellModelBundle,...
                             'stateValuesKFPost',emptyCellModelBundle,...
                             'stateValuesKFPrior',emptyCellModelBundle,...
                             'valuesNOKF',emptyCellModelBundle,...
                             'priorTimes',emptyCellModelBundle);

    
elseif strcmp(conf.modeStr,'soda')
    
    nStatesKF = conf.nStatesKF;
    nNOKF = conf.nNOKF;
    
    nanArrayKF = repmat(NaN,[nParSets,nMembers,nStatesKF,nPrior]);
    nanArrayNOKF = repmat(NaN,[nParSets,nMembers,nNOKF,nPrior]);
    
    stateValuesKFPrior = nanArrayKF;
    valuesNOKF = nanArrayNOKF;
    stateValuesKFPert = nanArrayKF;
    stateValuesKFPost = nanArrayKF;
    stateValuesKFInn = nanArrayKF;
    stochForce = nanArrayKF;
    obsPerturbations = nanArrayKF;
    obsPerturbed = nanArrayKF;
    
    % arrays without a time/DA dimension:
    measOperator = 1;
    ensembleCov = repmat(NaN,[nParSets,nStatesKF,nStatesKF]);
    measErrCov = repmat(NaN,[nParSets,nStatesKF,nStatesKF]);
    kalmanGain = repmat(NaN,[nParSets,nStatesKF,nStatesKF]);
    
    modelBundleTemplate = struct('type',emptyCellModelBundle,...
                                 'iEval',emptyCellModelBundle,...
                                 'iParSet',emptyCellModelBundle,...
                                 'iMember',emptyCellModelBundle,...
                                 'iDAStep',emptyCellModelBundle,...
                                 'parVec',emptyCellModelBundle,...
                                 'stateValuesKFPost',emptyCellModelBundle,...
                                 'stateValuesKFPrior',emptyCellModelBundle,...
                                 'valuesNOKF',emptyCellModelBundle,...
                                 'priorTimes',emptyCellModelBundle);
    

else
end

objectiveBundleTemplate = struct('type',emptyCellObjectiveBundle,...
                             'iEval',emptyCellObjectiveBundle,...
                             'iParSet',emptyCellObjectiveBundle,...
                             'parVec',emptyCellObjectiveBundle,...
                             'modelOutputs',emptyCellObjectiveBundle);


clear emptyCellModelBundle
clear emptyCellObjectiveBundle

switch conf.modeStr
    case 'bypass'
        % use this option for models without any states. Use the objective 
        % function to calculate density directly from the parameter vector.

    case {'reset','soda','scemua'}
        
        
        assimAtIx = find(conf.assimilate);


        switch conf.modeStr
            case 'reset'
                for iParSet=1:nParSets
                    for iMember=1:nMembers
                        % calculate unperturbed observations:
                        obsPerturbed(iParSet,iMember,1:nStatesKF,assimAtIx) = shiftdim(conf.obsState,-2);

                        switch conf.initMethodNOKF
                            case 'reference'
                                stateValuesKFPost(iParSet,iMember,1:nStatesKF,1) = conf.initValuesKF;
                                if ~isempty(conf.initValuesNOKF)
                                    valuesNOKF(iParSet,iMember,1:nNOKF,1) = conf.initValuesNOKF;
                                end
                            otherwise
                                error('no other method than ''reference'' available yet')
                        end

                    end
                end
            case 'soda'
                for iParSet=1:nParSets
                    for iMember=1:nMembers
%                         stochForce(iParSet,iMember,1:nStatesKF,1) = zeros(1,1,nStatesKF,1);
                        for iDAStep = 1:nDASteps
                            % generate model perturbations, white noise with covariance matrix covModelPert:
                            stochForce(iParSet,iMember,1:nStatesKF,assimAtIx(iDAStep)) = shiftdim(randn(1,nStatesKF)*...
                                sqrt(conf.covModelPert(1:nStatesKF,1:nStatesKF,iDAStep)),-1);
                            % generate observation perturbations, white noise with covariance matrix covObsPert:
                            obsPerturbations(iParSet,iMember,1:nStatesKF,assimAtIx(iDAStep)) = shiftdim(randn(1,nStatesKF)*...
                                sqrt(conf.covObsPert(1:nStatesKF,1:nStatesKF,iDAStep)),-1);

                            % calculate perturbed observations:
                            obsPerturbed(iParSet,iMember,1:nStatesKF,assimAtIx(iDAStep)) = shiftdim(conf.obsState(iDAStep),-2) + ...
                                                                                   obsPerturbations(iParSet,iMember,1:nStatesKF,assimAtIx(iDAStep));
                        end

                        switch conf.initMethodKF
                            case 'reference'
                                stateValuesKFPost(iParSet,iMember,1:nStatesKF,1) = conf.initValuesKF;
                                if ~isempty(conf.initValuesNOKF)
                                    valuesNOKF(iParSet,iMember,1:nNOKF,1) = conf.initValuesNOKF;
                                end
                            otherwise
                                error('no other method than ''reference'' available yet')
                        end

                    end
                end
            otherwise
        end
        
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

        for iDAStep = 1:nDASteps+1

            if iDAStep == 1
                s = 1;
            else
                s = assimAtIx(iDAStep-1);
            end
            if iDAStep == nDASteps+1
                e = nPrior;
            else
                e = assimAtIx(iDAStep);
            end
            if s==e
                continue
            end
            
            priorTimesChunk = conf.priorTimes(s:e);
            nPriorChunk = numel(priorTimesChunk);

            
            
            % use the template for preallocation
            bundle = modelBundleTemplate;

            % submit tasks:
            iTask = 0;
            iWorker = 0;
            for iParSet=1:nParSets
                for iMember=1:nMembers

                    iTask = iTask + 1;
                    bundle(iTask).type = 'model';
                    bundle(iTask).iEval = parsets(iParSet,conf.evalCol);
                    bundle(iTask).iParSet = iParSet;
                    bundle(iTask).iMember = iMember;
                    bundle(iTask).iDAStep = iDAStep;
                    bundle(iTask).parVec = parsets(iParSet,parCols);
                    bundle(iTask).priorTimes = priorTimesChunk';
                    
                    if strcmp(conf.modeStr,'scemua')
                        
                        bundle(iTask).modelOutput = repmat(NaN,[nOutputs,nPriorChunk]);
                        
                    elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')
                        
                        bundle(iTask).stateValuesKFPost = shiftdim(stateValuesKFPost(iParSet,iMember,1:nStatesKF,s),2);
                        bundle(iTask).stateValuesKFPrior = repmat(NaN,[nStatesKF,nPriorChunk]);
                        bundle(iTask).valuesNOKF = shiftdim(valuesNOKF(iParSet,iMember,1:nNOKF,s),2);
                        
                    else
                    end
    


                    if iTask==ceil((nParSets*nMembers)/nWorkers) || (iParSet==nParSets && iMember==nMembers)
                        nTasks = iTask;
                        if conf.executeInParallel
                            iWorker = iWorker + 1;
                            sendvar(iWorker,bundle(1:nTasks));
                            iTask = 0;
                        else
                            trPool.result = runmpirankOtherFun(conf,bundle(1:nTasks));
                        end
                        clear nTasks
                        clear bundle
                        if ~(iParSet==nParSets && iMember==nMembers)
                            % use the template for preallocation
                            bundle = modelBundleTemplate;
                        end
                    end
                end
            end

            if conf.executeInParallel
                nActiveWorkers = iWorker;

                % retrieve results:
                for i = 1:nActiveWorkers;
                    trPool(i).result=receivevar();
                end
                % save('dbg.mat')
            end


            nBundles = numel(trPool);
            for iBundle = 1:nBundles
                nResults = numel(trPool(iBundle).result);
                for iResult=1:nResults

                    result = trPool(iBundle).result(iResult);

                    iParSet = result.iParSet;
                    iMember = result.iMember;
                    
                    switch conf.modeStr
                        case 'scemua'
                            modelOutputs(iParSet,iMember,1:nOutputs,s+1:e) = shiftdim(result.modelOutput(1:nOutputs,2:nPriorChunk),-2);
                        case {'reset','soda'}
                            stateValuesKFPrior(iParSet,iMember,1:nStatesKF,s+1:e) = shiftdim(result.stateValuesKFPrior(1:nStatesKF,2:nPriorChunk),-2);
                            valuesNOKF(iParSet,iMember,1:nNOKF,s+1:e) = shiftdim(result.valuesNOKF(1:nNOKF,2:nPriorChunk),-2);
                        otherwise
                    end
                end
            end

            clear trPool

            switch conf.modeStr
                case 'reset'

                    % the posterior is equal to the observation for times
                    % when there is an observed state
                    stateValuesKFPost(1:nParSets,1:nMembers,1:nStatesKF,e) = obsPerturbed(1:nParSets,1:nMembers,1:nStatesKF,e);
                    
                    % the innovation is the difference between prior and
                    % posterior
                    stateValuesKFInn(1:nParSets,1:nMembers,1:nStatesKF,e) = stateValuesKFPost(1:nParSets,1:nMembers,1:nStatesKF,e) -...
                                                                                  stateValuesKFPrior(1:nParSets,1:nMembers,1:nStatesKF,e);

                case 'soda'

                    if conf.assimilate(e)
                        % stochForce exists as a 4D array with randn forcings.
                        % Add a model error to the simulated state values:
                        stateValuesKFPert(:,:,:,e) = stateValuesKFPrior(:,:,:,e) + stochForce(:,:,:,e);

                        % Compute the ensemble covariance matrix, Pe (See...
                        % Equation 47 of Evensen et al. 2002):
                        ensembleCov = mmsodaCalcEnsembleCov(stateValuesKFPert,e);

                        % Compute the measurement error covariance matrix, Re (See...
                        % Equation 51 of Evensen et al. 2002):
                        measErrCov = mmsodaCalcMeasErrCov(obsPerturbed,e);

                        % Calculate the classical Kalman Gain (See...
                        % Equation 52 of Evensen et al. 2002):
                        kalmanGain = mmsodaCalcKalmanGain(ensembleCov,measErrCov,measOperator,kalmanGain);

                        % Calculate the state innovations:
                        stateValuesKFInn = mmsodaCalcInnovations(kalmanGain,obsPerturbed,measOperator,stateValuesKFPert,stateValuesKFInn,e);

                        % Add innovation to ensemble of states (See Equation 54 of ...
                        % Evensen et al. 2002):
                        stateValuesKFPost = mmsodaUpdateStates(conf,stateValuesKFPert,stateValuesKFPost,stateValuesKFInn,e);
                    end

                otherwise
            end

        end

        
    otherwise
end


% use the template for preallocation
bundle = objectiveBundleTemplate;

% now submit the objective tasks:
iTask = 0;
iWorker = 0;
for iParSet=1:nParSets

    iTask = iTask + 1;

    bundle(iTask).type = 'objective';
    bundle(iTask).iEval = parsets(iParSet,conf.evalCol);
    bundle(iTask).iParSet = iParSet;
    bundle(iTask).parVec = parsets(iParSet,parCols);
    switch conf.modeStr
        case 'scemua'
            tmp = permute(modelOutputs(iParSet,1:nMembers,1:nOutputs,1:nPrior),[3,4,2,1]);
            bundle(iTask).modelOutputs = tmp;
        case {'reset','soda'}
            tmp = stateValuesKFPrior(iParSet,1:nMembers,1:nStatesKF,1:nPrior);
            bundle(iTask).allStateValuesKFPrior = permute(tmp,[3,4,2,1]);
            tmp = valuesNOKF(iParSet,1:nMembers,1:nNOKF,1:nPrior);
            bundle(iTask).allValuesNOKF = permute(tmp,[3,4,2,1]);
        otherwise
    end

    if iTask==ceil(nParSets/nWorkers) || iParSet==nParSets
        nTasks = iTask;
        if conf.executeInParallel
            iWorker = iWorker + 1;
            sendvar(iWorker,bundle(1:nTasks));
            iTask = 0;
        else
            trPool.result = runmpirankOtherFun(conf,bundle(1:nTasks));
        end
        clear bundle
        clear nTasks
        if iParSet<nParSets
            % use the template for preallocation
            bundle = objectiveBundleTemplate;
        end
    end
end


if conf.executeInParallel
    nActiveWorkers = iWorker;     
    % retrieve results:
    for i = 1:nActiveWorkers;
        trPool(i).result=receivevar();
    end
    % save('dbg.mat')
end

nBundles = numel(trPool);
for iBundle = 1:nBundles
    nResults = numel(trPool(iBundle).result);
    for iResult=1:nResults

        result = trPool(iBundle).result(iResult);

        iParSet = result.iParSet;
        parsets(iParSet,conf.llCols) = result.llScores;
    end
end
clear trPool


if conf.saveEnKFResults
    if conf.isSingleObjective
        soMoStr = '-so';
    elseif conf.isMultiObjective
        soMoStr = '-mo';
    else
    end
    
    fname = fullfile('results',[conf.modeStr,soMoStr,sprintf('-results-enkf-evals-%d-%d.mat',...
        parsets(1,evalCol),parsets(nParSets,evalCol))]);
    
    if strcmp(conf.modeStr,'scemua')
        
        save(fname,'-mat','parsets','modelOutputs')
        
    elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')
        
        save(fname,'-mat','parsets','stateValuesKFPrior',...
            'stateValuesKFPert','stateValuesKFPost','stateValuesKFInn',...
            'stochForce','obsPerturbations','obsPerturbed','valuesNOKF')
    end
end
