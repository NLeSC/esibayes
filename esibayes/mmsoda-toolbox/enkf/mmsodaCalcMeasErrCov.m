function measErrCov = mmsodaCalcMeasErrCov(obsPerturbed,iDAStep)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcMeasErrCov.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>




[nParSets,nMembers,nStatesKF,nDASteps] = size(obsPerturbed);

for iParSet=1:nParSets
    A = obsPerturbed(iParSet,1:nMembers,1:nStatesKF,iDAStep);
    B = shiftdim(A,1);
    measErrCov(iParSet,1:nStatesKF,1:nStatesKF) = cov(B);
end
