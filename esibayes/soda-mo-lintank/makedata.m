function makedata()


R = 50;
simWaterLevel(1,1) = 45;
simQ(1,1) = NaN;
modeStr = 'inv';
timeStep = 1;
timeVec=[0:timeStep:30];
nTimes = numel(timeVec);

for iTime=2:nTimes

    timeNow = timeVec(iTime);

    switch modeStr
        case 'fwd'
            if timeNow == 20
                simWaterLevel(1,iTime-1) = simWaterLevel(1,iTime-1) *1.30;
            end
        case 'inv'
        otherwise
        end
    simQ(1,iTime) = simWaterLevel(1,iTime-1)*-(1/R);
    simWaterLevel(1,iTime) = simWaterLevel(1,iTime-1) + simQ(1,iTime)*timeStep;
end

obsQ = simQ;
obsWaterLevel = simWaterLevel;
obsTime = timeVec;

figure
subplot(2,1,1)
plot(obsTime,obsWaterLevel,'-b.');
subplot(2,1,2)
plot(obsTime-0.5*timeStep,obsQ,'-.b')


if uioctave
    %save('./data/obs.o.mat','-binary','obsWaterLevel','obsTime','obsQ','timeStep')
    save('./data/obs.m.mat','-mat7-binary','obsWaterLevel','obsTime','obsQ','timeStep')
elseif uimatlab || isdeployed
    save('./data/obs.m.mat','-mat','obsWaterLevel','obsTime','obsQ','timeStep')
else
end



clear

% load the observations that were just created by 'makedata'
load('./data/obs.m.mat','obsWaterLevel','obsTime','obsQ','timeStep')
simTime = obsTime;

% define which variables are constants (i.e. for all parameter combinations, ensemble members, and data assimilation steps)
mConstants = {'timeStep',1;...
              'obsTime',obsTime;...
              'obsQ',obsQ;...
              'obsWaterLevel',obsWaterLevel;...
              'modeStr','inv'};
          
save('./data/constants.m.mat','mConstants')          


