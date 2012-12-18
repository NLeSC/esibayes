function stateValuesKFPost = sodaUpdateStates(conf,stateValuesKFPert,stateValuesKFPost,stateValuesKFInn,iDAStep)

%function mStatesPost = sodaUpdateStates(conf,mStatesPert,mStatesPost,stateInn,iIter)

%nStatesKF = conf.nStatesKF;
%nMembers = conf.nEnsembleMembers;


%updatedState = mStatesPert(iIter+1,1:nStatesKF,1:nMembers)+...
    %stateInn(iIter+1,1:nStatesKF,1:nMembers);



%% check for consistency:

%for iMember = 1:nMembers
    %for iStateKF = 1:nStatesKF
        %if updatedState(1,iStateKF,iMember) > conf.stateSpaceHiBound(iStateKF)
            %mStatesPost(iIter+1,iStateKF,iMember) = conf.stateSpaceHiBound(iStateKF);
        %elseif updatedState(1,iStateKF,iMember) < conf.stateSpaceLoBound(iStateKF)
            %mStatesPost(iIter+1,iStateKF,iMember) = conf.stateSpaceLoBound(iStateKF);
        %else
            %mStatesPost(iIter+1,iStateKF,iMember) = updatedState(1,iStateKF,iMember);
        %end
    %end
%end


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
