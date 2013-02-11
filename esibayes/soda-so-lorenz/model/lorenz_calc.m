function uprime = lorenz_calc(t,u,flag,parVec)
% Calculates function values

parSigma = parVec(1);
parBeta = parVec(2);
parRho = parVec(3);


uprime = [parSigma * (u(2)-u(1));... 
          parRho*u(1) - u(2) - u(1)*u(3);... 
          u(1)*u(2) - parBeta*u(3)];
