
% Runs the HYMOD model
clear
close all
clc

% set the parameters:
cmax = 300;
bexp = 0.2;
fQuickFlow = 0.3;
Rs = 0.01;
Rq = 0.4;

% load the artificial observations:
load('observations.mat')


iStart = 1;
iEnd = 795;
wu = 65;
convFactor = 22.5;

timeVec = numTime(iStart:iEnd);
nTimes = numel(timeVec);

dailyDischargeSim = repmat(NaN,[1,nTimes]);

outflow = [];


% initialize the states
x_loss = 0.0;

% Initialize slow tank state
x_slow = 2.3503/(Rs*convFactor);

% Initialize state(s) of quick tank(s)
x_quick(1:3,1) = 0;


% iterate over the time vector:

for iTime = 1:nTimes-1
    
    tPrev = timeVec(iTime);
    tNow = tPrev;
    tNext = timeVec(iTime+1);
    
    
    iNow = find(tNow == numTime);
    
    Pval = dailyPrecip(iNow+1,1);
    PETval = dailyPotEvapTrans(iNow+1,1);
    
    % Compute excess precipitation and evaporation
    [UT1,UT2,x_loss] = excess(x_loss,cmax,bexp,Pval,PETval);
    
    % Partition UT1 and UT2 into quick and slow flow component
    UQ = fQuickFlow*UT2 + UT1;
    US = (1-fQuickFlow)*UT2;
    
    % Route slow flow component with single linear reservoir
    inflow = US;
    [x_slow,outflow] = linres(x_slow,inflow,outflow,Rs);
    QS = outflow;
    
    % Route quick flow component with linear reservoirs
    inflow = UQ;
    for k=1:3
        [x_quick(k),outflow] = linres(x_quick(k),inflow,outflow,Rq);
        inflow = outflow;
    end
    
    % Compute total flow for timestep
    dailyDischargeSim(1,iTime+1) = (QS + outflow)*convFactor;
end




figure
plot(timeVec,dailyDischarge(iStart:iEnd),'.b',...
     timeVec,dailyDischargeSim,'-m')
datetick('x')
ylabel('flow [m^3/s]')
title('artificial data example of the HYMOD model')




