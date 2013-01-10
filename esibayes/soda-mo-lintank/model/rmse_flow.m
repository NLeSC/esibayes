function objScore = rmse_flow(conf,constants,allStateValuesKF,allValuesNOKF,parVec)

sodaUnpack()


[tmp,nMembers,nNOKF,nDASteps] = size(allValuesNOKF);

memberDim = 2;
outputCol = 2; % the 2nd position in allValuesNOKF(iParSet,iMember,2,1:nDASteps) holds the 'Q' information

simQMean = shiftdim(mean(allValuesNOKF(1,1:nMembers,outputCol,1:nDASteps),memberDim),2);

objScore = sqrt(mean((obsQ(2:nDASteps)-simQMean(2:nDASteps)).^2));

% save('./../streams/debug.m.mat','-mat7-binary')
% save('./../streams/debug.o.mat','-binary')
