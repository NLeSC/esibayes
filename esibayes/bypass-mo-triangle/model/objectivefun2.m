function objScore = objectivefun2(mConstants,allStateValuesKF,allValuesNOKF,parVec)

theta1 = parVec(1);
theta2 = parVec(2);

objScore = (theta1-1)^2 + theta2^2;