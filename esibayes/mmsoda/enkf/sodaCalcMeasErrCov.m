function measErrCov = sodaCalcMeasErrCov(obsPerturbed,iDAStep)

%nStatesKF = conf.nStatesKF;
%nMembers = conf.nEnsembleMembers;

%M(1:nMembers,1:nStatesKF) = shiftdim(perturbedObs(iIter+1,1:nStatesKF,1:nMembers),1)';

%measErrCov = cov(M);




[nParSets,nMembers,nStatesKF,nDASteps] = size(obsPerturbed);

for iParSet=1:nParSets
    A = obsPerturbed(iParSet,1:nMembers,1:nStatesKF,iDAStep);
    B = shiftdim(A,1);
    measErrCov(iParSet,1:nStatesKF,1:nStatesKF) = cov(B);
end
