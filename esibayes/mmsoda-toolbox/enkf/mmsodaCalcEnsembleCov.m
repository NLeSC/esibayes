function ensembleCov = mmsodaCalcEnsembleCov(stateValuesKFPert,iDAStep)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcEnsembleCov.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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

for iParSet=1:nParSets
    A = stateValuesKFPert(iParSet,1:nMembers,1:nStatesKF,iDAStep);
    B = shiftdim(A,1);
    ensembleCov(iParSet,1:nStatesKF,1:nStatesKF) = cov(B);
end

