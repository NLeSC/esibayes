function stateValuesKFInn = mmsodaCalcInnovations(kalmanGain,obsPerturbed,measOperator,stateValuesKFPert,stateValuesKFInn,iDAStep)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcInnovations.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


[nParSets,nMembers,nStatesKF,nDASteps] = size(stateValuesKFPert);


for iParSet=1:nParSets

    KG = shiftdim(kalmanGain(iParSet,1:nStatesKF,1:nStatesKF),1);

    for iMember=1:nMembers
        A = shiftdim(obsPerturbed(iParSet,iMember,1:nStatesKF,iDAStep),2);
        B = shiftdim(stateValuesKFPert(iParSet,iMember,1:nStatesKF,iDAStep),2);

        stateValuesKFInn(iParSet,iMember,1:nStatesKF,iDAStep) = shiftdim(KG*(A-measOperator*B),-2);

    end

end

