function objScore = calcLikelihood(conf,constants,modelOutput,parVec)

sodaUnpack()

dens = (1/(sqrt(2*pi*parSigma1^2))*exp(-(1/2)*((x-parMu1)/parSigma1)^2) + ...
        1/(sqrt(2*pi*parSigma2^2))*exp(-(1/2)*((x-parMu2)/parSigma2)^2))/2;

objScore = log(dens);

