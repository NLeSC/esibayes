function kalmanGain = mmsodaCalcKalmanGain(ensembleCov,measErrCov,measOperator,kalmanGain)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcKalmanGain.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


nParSets = size(ensembleCov,1);
nStatesKF = size(ensembleCov,2);


for iParSet=1:nParSets
    A = shiftdim(ensembleCov(iParSet,1:nStatesKF,1:nStatesKF),1);
    B = shiftdim(measErrCov(iParSet,1:nStatesKF,1:nStatesKF),1);
    kalmanGain(iParSet,1:nStatesKF,1:nStatesKF) = A*measOperator'*...
         inv(measOperator*A*measOperator' + B);
end
