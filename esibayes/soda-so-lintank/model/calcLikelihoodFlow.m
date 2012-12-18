function objScore = rmse_flow(mConstants,allStateValuesKF,allValuesNOKF,parVec)


% map the constants values to their respective variables:
for iConstant=1:size(mConstants,1)
   eval([mConstants{iConstant,1},'=mConstants{iConstant,2};'])
end


[tmp,nMembers,nNOKF,nDASteps] = size(allValuesNOKF);

iParSet = 1;
flowCol = 2; % the 2nd position in allValuesNOKF(iParSet,iMember,2,1:nDASteps) holds the 'Q' information

% log likelihood based on Eq 1.20 in my pdf
term1 = sqrt(2*pi*obsQSigma^2);
ensembleDens = repmat(NaN,[nMembers,1]);
for iMember=1:nMembers
    simQ = shiftdim(allValuesNOKF(iParSet,iMember,flowCol,1:nDASteps),2);

    Err = simQ(2:nDASteps) - obsQ(2:nDASteps);
    term2 = -(1/2)*sum((Err/obsQSigma).^2);
    
    ensembleDens(iMember) = -(nDASteps-1) * log(term1) + term2;
end

objScore = mean(ensembleDens);
