function stateValuesKFInn = sodaCalcInnovations(kalmanGain,obsPerturbed,measOperator,stateValuesKFPert,stateValuesKFInn,iDAStep)
%function stateInn = sodaCalcInnovations(conf,kalmanGain,perturbedObs,measOperator,...
        %mStatesOutEnsemble,stateInn,iIter)

% for qq = 1:States.N,
%    Inn(tt,1:States.n,qq) = (Kg(:,:,tt)*(D(qq,1:States.n)'-(H*A(tt,1:States.n,qq))'))';
% end;

% Inn(iIter,:,:) = kalmanGain*perturbedObs(iIter,:)'-...
%     measOperator*mStatesOutEnsemble


%nMembers = conf.nEnsembleMembers;
%nStatesKF = conf.nStatesKF;

%KG = shiftdim(kalmanGain(iIter+1,1:nStatesKF,1:nStatesKF),1);

%for iMember = 1:nMembers
    %stateInn(iIter+1,1:nStatesKF,iMember) = (KG*...
        %(perturbedObs(iIter+1,1:nStatesKF,iMember)'-...
        %(measOperator*mStatesOutEnsemble(iIter+1,1:nStatesKF,iMember))'))';
%end



[nParSets,nMembers,nStatesKF,nDASteps] = size(stateValuesKFPert);

%save('debug.mat')
%while true
%end

for iParSet=1:nParSets

    KG = shiftdim(kalmanGain(iParSet,1:nStatesKF,1:nStatesKF),1);

    for iMember=1:nMembers
        A = shiftdim(obsPerturbed(iParSet,iMember,1:nStatesKF,iDAStep),2);
        B = shiftdim(stateValuesKFPert(iParSet,iMember,1:nStatesKF,iDAStep),2);

        stateValuesKFInn(iParSet,iMember,1:nStatesKF,iDAStep) = shiftdim(KG*(A-measOperator*B),-2);

    end

end







% this works: ->
%stateValuesKFInn(1:nParSets,1:nMembers,1:nStatesKF,iDAStep) = ...
%                     obsPerturbed(1:nParSets,1:nMembers,1:nStatesKF,iDAStep) - ...
%                     stateValuesKFPert(1:nParSets,1:nMembers,1:nStatesKF,iDAStep);
