function stateValuesKFPost = mmsodaUpdateStates(conf,stateValuesKFPert,stateValuesKFPost,stateValuesKFInn,iDAStep)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaUpdateStates.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% % 

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END


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
