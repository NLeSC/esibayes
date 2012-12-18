function objScore = calcLikelihood(mConstants,allStateValuesKF,allValuesNOKF,parVec)
% function doublenormal calculates the density directly, so calculating the
% likelihood is a matter of passing the information from allValuesNOKF on to
% the variable objScore;


% map the parameter values to their respective variables:
x = parVec(1);

% map the constants values to their respective variables:
for iConstant=1:size(mConstants,1)
    eval([mConstants{iConstant,1},'=mConstants{iConstant,2};'])
end

dens = (1/(sqrt(2*pi*parSigma1^2))*exp(-(1/2)*((x-parMu1)/parSigma1)^2) + ...
        1/(sqrt(2*pi*parSigma2^2))*exp(-(1/2)*((x-parMu2)/parSigma2)^2))/2;


objScore = log(dens);
