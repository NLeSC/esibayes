function stateValuesKFPost = mmsodaUpdateStates(conf,stateValuesKFPert,stateValuesKFPost,stateValuesKFInn,iDAStep)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaUpdateStates.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

[nParSets,nMembers,nStatesKF,nDASteps] = size(stateValuesKFPert);

updatedState = stateValuesKFPert(1:nParSets,1:nMembers,1:nStatesKF,iDAStep) +...
               stateValuesKFInn(1:nParSets,1:nMembers,1:nStatesKF,iDAStep);


for iParSet=1:nParSets
    for iMember=1:nMembers
        for iStateKF=1:nStatesKF

            if updatedState(iParSet,iMember,iStateKF) > conf.stateSpaceHiBound(1,iStateKF)
                stateValuesKFPost(iParSet,iMember,iStateKF,iDAStep) = conf.stateSpaceHiBound(1,iStateKF);

            elseif updatedState(iParSet,iMember,iStateKF) < conf.stateSpaceLoBound(1,iStateKF)
                stateValuesKFPost(iParSet,iMember,iStateKF,iDAStep) = conf.stateSpaceLoBound(1,iStateKF);

            else
                stateValuesKFPost(iParSet,iMember,iStateKF,iDAStep) = updatedState(iParSet,iMember,iStateKF,1);

            end

        end
    end
end
