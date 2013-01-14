function objScore = calcLikelihoodState(conf,constants,allStateValuesKFPrior,allValuesNOKF,parVec)

sodaUnpack()


[nParsets,nMembers,nNOKF,nPrior] = size(allValuesNOKF);

if nParsets == 1
    iParSet = 1;
end

stateCol = 1; % the 1st position in allStateValuesKFPrior(iParSet,iMember,1,1:nDASteps) holds the state information that i'm interested in

% log likelihood based on Eq 1.20 in my pdf
term1 = sqrt(2*pi*obsStateSigma^2);
ensembleDens = repmat(NaN,[nMembers,1]);
for iMember=1:nMembers
    simState = shiftdim(allStateValuesKFPrior(iParSet,iMember,stateCol,1:nPrior),2);

    Err = simState(2:nPrior) - obsWaterLevel(2:nPrior);
    term2 = -(1/2)*sum((Err/obsStateSigma).^2);
    
    ensembleDens(iMember) = -(nPrior-1) * log(term1) + term2;
end

objScore = mean(ensembleDens);
