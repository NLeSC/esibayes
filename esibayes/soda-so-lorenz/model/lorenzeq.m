function modelOutput = lorenzeq(conf,constants,init,parVec,priorTimes) 


odeOptions = odeset('RelTol',1e-6,'AbsTol',1e-6);
[~,u] = ode45('lorenz_calc',priorTimes,init,odeOptions,parVec);

modelOutput = permute(u(:,1:3),[2,1]);
