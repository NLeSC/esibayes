function ensembleCov = mmsodaCalcEnsembleCov(stateValuesKFPert,iDAStep)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcEnsembleCov.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>



[nParSets,nMembers,nStatesKF,nDASteps] = size(stateValuesKFPert);

for iParSet=1:nParSets
    A = stateValuesKFPert(iParSet,1:nMembers,1:nStatesKF,iDAStep);
    B = shiftdim(A,1);
    ensembleCov(iParSet,1:nStatesKF,1:nStatesKF) = cov(B);
end

