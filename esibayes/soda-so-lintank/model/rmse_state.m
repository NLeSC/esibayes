function objScore = rmse_state(mConstants,allStateValuesKF,allValuesNOKF)


% map the constants values to their respective variables:
for iConstant=1:size(mConstants,1)
   eval([mConstants{iConstant,1},'=mConstants{iConstant,2};'])
end


[tmp,nMembers,nKF,nDASteps] = size(allStateValuesKF);

memberDim = 2;
selectCol = 1; % the 1st position in allStateValuesKF(iParSet,iMember,1,1:nDASteps) holds the state information

simWaterLevelMean = shiftdim(mean(allStateValuesKF(1,1:nMembers,selectCol,1:nDASteps),memberDim),2);

objScore = sqrt(mean((obsWaterLevel(2:nDASteps)-simWaterLevelMean(2:nDASteps)).^2));

% save('./../streams/debug.mat','-mat7-binary')
