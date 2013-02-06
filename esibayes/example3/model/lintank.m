function modelOutput = lintank(conf,constants,init,parVec,priorTimes)

% unpack the information from the input arguments and assign it to the
% correct variables
sodaUnpack()

% initialize the current simulated time as the first entry in 'priorTimes'
tNow = priorTimes(1);
% initialize the last simulated time as the last entry in 'priorTimes'
tEnd = priorTimes(end);

% assign the upper tank state variable its initial value
state1 = state1Init;

% assign the lower tank state variable its initial value
state2 = state2Init;

% initialize an array for recording 'tNow', 'state1', and 'state2'
rec = [tNow,state1,state2];

while tNow < tEnd

    % retrieve the index in 'priorTimes' of the next observation time:
    iPriorNext = find(tNow<priorTimes,1,'first');
    
    % In principle, the model proceeds by time steps of 'dtSimDefault'. However, 
    % if that results in values of 'tNow' beyond the next time of observation
    % 'priorTimes(iPriorNext)', then we use a shorter model 
    % integration time step 'dtSim = priorTimes(iPriorNext) - tNow' instead.
    dtSim = min([dtSimDefault,priorTimes(iPriorNext) - tNow]);

    % calculate the instantaneous discharge from 'state1' and the resistance parameter 'R':
    Q = state1/-R;
    
    % integrate the discharge from the first tank over the interval dtSim
    dState = Q * dtSim;
    
    % decrease the volume in the first tank by dV (which is negative, hence the + sign)
    state1 = state1 + dState;
    
    % increase the volume in the first tank by dV (which is negative, hence the - sign)
    state2 = state2 - dState;

    % increment the current time by the model integration time step
    tNow = tNow + dtSim;
    
    % record the current time, state1 and state2
    rec = [rec;tNow,state1,state2];
    
end

% figure(1)
% plot(rec(:,1),rec(:,2),'-b.',rec(:,1),rec(:,3),'-m.')
% set(gca,'xtick',rec(:,1))
% xlabel('Time')
% ylabel('State')
% legend('state 1','state 2')
% drawnow


% transpose 'rec' because the output argument 'stateValuesKFNew' must have 'nOutputs' rows and 
% nPrior columns
rec = rec';
% find the columns in the transposed 'rec' array that contain the values of 'state1' and 'state2'
% at the times listed in 'priorTimes':
c = ismember(rec(1,:),priorTimes);
% extract those columns from 'rec' and assign to the output argument 'stateValuesKFNew'
modelOutput = rec(2:3,c);

