function objScore = calcLikelihoodFlow(mConstants,allStateValuesKF,allValuesNOKF,parVec)

for iConstant = 1:size(mConstants,1)
    eval([mConstants{iConstant,1},' = mConstants{iConstant,2};'])
end

[nParsets,nMembers,nNOKF,nPrior] = size(allValuesNOKF);

if nParsets~=1
    error('Number of parameter sets should be 1.')
else
    iParSet = nParsets;
end

obs = dailyDischarge([iStart,iStart+wu:iEnd])';

% the 1st position in the 3rd dimension of 
% allValuesNOKF(iParSet,iMember,1,1:nPrior) holds the 'Q' information
flowCol = 1; 

% log likelihood based on Eq 1.20 in my pdf
term1 = sqrt(2*pi*obsQSigma^2);
ensembleDens = repmat(NaN,[nMembers,1]);
for iMember=1:nMembers
    sim = shiftdim(allValuesNOKF(iParSet,iMember,flowCol,1:nPrior),2);

    Err = sim(2:nPrior) - obs(2:nPrior);
    term2 = -(1/2)*sum((Err/obsQSigma).^2);
    
    ensembleDens(iMember) = -(nPrior-1) * log(term1) + term2;
end

objScore = mean(ensembleDens);
