function parsets = sodaEnKF(conf,parsets)
%function parsets = sodaEnKF(conf,parsets)

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
nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;
nDASteps = conf.nDASteps;
nPrior = conf.nPrior;

nanArrayKF = repmat(NaN,[nParSets,nMembers,nStatesKF,nPrior]);
nanArrayNOKF = repmat(NaN,[nParSets,nMembers,nNOKF,nPrior]);

stateValuesKFPrior = nanArrayKF;
valuesNOKF = nanArrayNOKF;

switch conf.modeStr
    case 'bypass'
        % use this option for models without any states. Use the objective 
        % function to calculate density directly from the parameter vector.

    case {'reset','soda','scemua'}
        
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
        
        assimAtIx = find(conf.assimilate);


        switch conf.modeStr
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
                                valuesNOKF(iParSet,iMember,1:nNOKF,1) = conf.initValuesNOKF;
                            otherwise
                                error('no other method than ''reference'' available yet')
                        end

                    end
                end
            case 'reset'
                for iParSet=1:nParSets
                    for iMember=1:nMembers
                        % calculate unperturbed observations:
                        obsPerturbed(iParSet,iMember,1:nStatesKF,assimAtIx) = shiftdim(conf.obsState,-2);

                        switch conf.initMethodNOKF
                            case 'reference'
                                stateValuesKFPost(iParSet,iMember,1:nStatesKF,1) = conf.initValuesKF;
                                valuesNOKF(iParSet,iMember,1:nNOKF,1) = conf.initValuesNOKF;
                            otherwise
                                error('no other method than ''reference'' available yet')
                        end

                    end
                end
            otherwise
        end
        
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

% 
%         for iParSet=1:nParSets
%             for iMember=1:nMembers
%                 switch conf.initMethodKF
%                     case 'reference'
%                         stateValuesKFPost(iParSet,iMember,1:nStatesKF,1) = conf.initValuesKF;
%                     otherwise
%                         error('no other method than ''reference'' available yet')
%                 end
%                 switch conf.initMethodNOKF
%                     case 'reference'
%                         valuesNOKF(iParSet,iMember,1:nNOKF,1) = conf.initValuesNOKF;
%                     otherwise
%                         error('no other method than ''reference'' available yet')
%                 end
%             end
%         end



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
            
%             clear s 
%             clear e
            

            % submit tasks:
            iTask = 0;
            for iParSet=1:nParSets
                for iMember=1:nMembers

                    iTask = iTask + 1;

                    bundle(iTask).type = 'model';
                    bundle(iTask).iEval = parsets(iParSet,conf.evalCol);
                    bundle(iTask).iParSet = iParSet;
                    bundle(iTask).iMember = iMember;
                    bundle(iTask).iDAStep = iDAStep;
                    bundle(iTask).parVec = parsets(iParSet,parCols);
                    bundle(iTask).stateValuesKFPost = shiftdim(stateValuesKFPost(iParSet,iMember,1:nStatesKF,s),2);
                    bundle(iTask).stateValuesKFPrior = repmat(NaN,[nStatesKF,nPriorChunk]);                    
                    bundle(iTask).valuesNOKF = shiftdim(valuesNOKF(iParSet,iMember,1:nNOKF,s),2);
                    bundle(iTask).priorTimes = priorTimesChunk;

                    if iTask==ceil((nParSets*nMembers)/nWorkers) || (iParSet==nParSets && iMember==nMembers)
                        if conf.executeInParallel

                            puttask(bundle);
                            iTask = 0;
                        else
                            trPool.result = runmpirankOtherFun(conf,bundle);
                        end
                        clear bundle
                    end
                end
            end


            if conf.executeInParallel
                % retrieve results:
                trPool = waitForResults();
                % save('dbg.mat')
            end


            nBundles = numel(trPool);
            for iBundle = 1:nBundles
                nResults = numel(trPool(iBundle).result);
                for iResult=1:nResults

                    result = trPool(iBundle).result(iResult);

                    iParSet = result.iParSet;
                    iMember = result.iMember;
                    
                    stateValuesKFPrior(iParSet,iMember,1:nStatesKF,s+1:e) = shiftdim(result.stateValuesKFPrior(1:nStatesKF,2:nPriorChunk),-2);
                    valuesNOKF(iParSet,iMember,1:nNOKF,s+1:e) = shiftdim(result.valuesNOKF(1:nNOKF,2:nPriorChunk),-2);
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
                        ensembleCov = sodaCalcEnsembleCov(stateValuesKFPert,e);

                        % Compute the measurement error covariance matrix, Re (See...
                        % Equation 51 of Evensen et al. 2002):
                        measErrCov = sodaCalcMeasErrCov(obsPerturbed,e);

                        % Calculate the classical Kalman Gain (See...
                        % Equation 52 of Evensen et al. 2002):
                        kalmanGain = sodaCalcKalmanGain(ensembleCov,measErrCov,measOperator,kalmanGain);

                        % Calculate the state innovations:
                        stateValuesKFInn = sodaCalcInnovations(kalmanGain,obsPerturbed,measOperator,stateValuesKFPert,stateValuesKFInn,e);

                        % Add innovation to ensemble of states (See Equation 54 of ...
                        % Evensen et al. 2002):
                        stateValuesKFPost = sodaUpdateStates(conf,stateValuesKFPert,stateValuesKFPost,stateValuesKFInn,e);
                    end

                otherwise
            end
        end

        
    otherwise
end


% now submit the objective tasks:
iTask = 0;
for iParSet=1:nParSets

    iTask = iTask + 1;

    bundle(iTask).type = 'objective';
    bundle(iTask).iEval = parsets(iParSet,conf.evalCol);
    bundle(iTask).iParSet = iParSet;
    bundle(iTask).parVec = parsets(iParSet,parCols);
    bundle(iTask).allStateValuesKFPrior = stateValuesKFPrior(iParSet,1:nMembers,1:nStatesKF,1:nPrior);
    bundle(iTask).allValuesNOKF = valuesNOKF(iParSet,1:nMembers,1:nNOKF,1:nPrior);

    if iTask==ceil(nParSets/nWorkers) || iParSet==nParSets
        if conf.executeInParallel

            puttask(bundle);
            iTask = 0;
        else
            trPool.result = runmpirankOtherFun(conf,bundle);
        end
        clear bundle
    end
end

if conf.executeInParallel
    % retrieve results:
    trPool = waitForResults();
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

if any(strcmp(conf.modeStr,{'soda','reset','scemua'}))
    if conf.saveEnKFResults
        fname = ['./results/',conf.modeStr,sprintf('-results-enkf-evals-%d-%d.m.mat',...
                                parsets(1,evalCol),parsets(nParSets,evalCol))];
        if uimatlab || isdeployed
            save(fname,'-mat','parsets','stateValuesKFPrior',...
                'stateValuesKFPert','stateValuesKFPost','stateValuesKFInn',...
                'stochForce','obsPerturbations','obsPerturbed','valuesNOKF')
        elseif uioctave
            save(fname,'-mat7-binary','parsets','stateValuesKFPrior',...
                'stateValuesKFPert','stateValuesKFPost','stateValuesKFInn',...
                'stochForce','obsPerturbations','obsPerturbed','valuesNOKF')
        else
        end
    end
end
