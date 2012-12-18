function kalmanGain = sodaCalcKalmanGain(ensembleCov,measErrCov,measOperator,kalmanGain)

%warning('off','MATLAB:nearlySingularMatrix')
%kalmanGain(iIter+1,:,:) = ensembleCov*measOperator'*...
    %inv(measOperator*ensembleCov*measOperator'+measErrCov);
%warning('on','MATLAB:nearlySingularMatrix')


%disp('')
nParSets = size(ensembleCov,1);
nStatesKF = size(ensembleCov,2);


for iParSet=1:nParSets
    A = shiftdim(ensembleCov(iParSet,1:nStatesKF,1:nStatesKF),1);
    B = shiftdim(measErrCov(iParSet,1:nStatesKF,1:nStatesKF),1);
    kalmanGain(iParSet,1:nStatesKF,1:nStatesKF) = A*measOperator'*...
         inv(measOperator*A*measOperator' + B);
end
