function makedata()



conf = [];
constants = [];
init = [1.508870;-1.531271;25.46091];

parVec = [10,8/3,28];

priorTimes = [0:0.25:40.0]  % was 40.0

simState = lorenzeq(conf,constants,init,parVec,priorTimes);

[nRows,nCols] = size(simState);

gaussTerm = randn(nRows,nCols) * sqrt(2.0);

obsState = simState + gaussTerm;


figure
plot3(obsState(1,:),obsState(2,:),obsState(3,:),'.')


save('./data/obs.mat','simState','gaussTerm','obsState')