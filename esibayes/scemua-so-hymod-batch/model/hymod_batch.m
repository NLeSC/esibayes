function [stateValuesKFNew,valuesNOKFNew] = hymod_batch(conf,mConstants,stateValuesKFOld,valuesNOKFOld,parVec,priorTimes)
% function output = hymod(parVec,Extra)
% Runs the HYMOD model

sodaUnpack()

tStart = priorTimes(1);
tEnd = priorTimes(end);

x_loss = 0.0;

% Initialize slow tank state
x_slow = 2.3503/(Rs*convFactor);

% Initialize state(s) of quick tank(s)
x_quick(1:3,1) = 0;

outflow = [];

nPrior = numel(priorTimes);

tempOutput = repmat(NaN,[1,nPrior]);


for iPrior = 1:nPrior-1

    tPrev = priorTimes(iPrior);
    tNow = tPrev;
    tNext = priorTimes(iPrior+1);

    while tNow < tNext
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


         tNow = tNow + 1;
    end
    % Compute total flow for timestep
    tempOutput(1,iPrior+1) = (QS + outflow)*convFactor;
end


nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;
nPrior = numel(conf.priorTimes);
stateValuesKFNew(1:nStatesKF,1:nPrior) = repmat(NaN,[nStatesKF,nPrior]);

valuesNOKFNew(1:nNOKF,1) = NaN;
valuesNOKFNew(1:nNOKF,2:nPrior) = tempOutput(1,2:nPrior);





