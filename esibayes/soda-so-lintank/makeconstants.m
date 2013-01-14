function makeconstants()


R = 50;
obsStateSigma = 1e-10;

simWaterLevelInit = 45;
simWaterLevel(1,1) = simWaterLevelInit;
simQ(1,1) = NaN;
modeStr = 'fwd';
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


randnTerm = obsStateSigma*randn(size(simWaterLevel));
obsQ = simQ;
obsWaterLevel = simWaterLevel + randnTerm;
obsTime = timeVec;

% figure
% subplot(2,1,1)
% plot(obsTime,obsWaterLevel,'-b.');
% subplot(2,1,2)
% plot(obsTime-0.5*timeStep,obsQ,'-.b')
% 
% 
% save('./data/obs.mat','-mat','obsWaterLevel','obsTime','obsQ','timeStep')

clear R
clear iTime
clear nTimes
clear simQ
clear simWaterLevel
clear simWaterLevelLimit
clear timeNow
clear timeVec

modeStr = 'inv';

save('./data/constants.mat','-mat')
