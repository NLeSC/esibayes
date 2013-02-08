function ensembleCov = sodaCalcEnsembleCov(stateValuesKFPert,iDAStep);
%ensembleCov = sodaCalcEnsembleCov(mStatesPriorPert,iIter)

%A = mStatesPriorPert(iIter+1,:,:);
%B = shiftdim(A,1)';
%ensembleCov = cov(B);


%iIter,nStates,nMembers



[nParSets,nMembers,nStatesKF,nDASteps] = size(stateValuesKFPert);

for iParSet=1:nParSets
    A = stateValuesKFPert(iParSet,1:nMembers,1:nStatesKF,iDAStep);
    B = shiftdim(A,1);
    ensembleCov(iParSet,1:nStatesKF,1:nStatesKF) = cov(B);
end

