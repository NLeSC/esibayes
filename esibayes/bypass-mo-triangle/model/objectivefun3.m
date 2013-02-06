function objScore = objectivefun3(conf,constants,modelOutput,parVec)

theta1 = parVec(1);
theta2 = parVec(2);

objScore = theta1^2+(theta2-1)^2;