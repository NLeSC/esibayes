function objScore = objectivefun1(conf,constants,modelOutput,parVec)

theta1 = parVec(1);
theta2 = parVec(2);

objScore = theta1^2+theta2^2;