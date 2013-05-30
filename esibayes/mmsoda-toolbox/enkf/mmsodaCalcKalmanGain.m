function kalmanGain = mmsodaCalcKalmanGain(ensembleCov,measErrCov,measOperator,kalmanGain)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcKalmanGain.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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


nParSets = size(ensembleCov,1);
nStatesKF = size(ensembleCov,2);


for iParSet=1:nParSets
    A = shiftdim(ensembleCov(iParSet,1:nStatesKF,1:nStatesKF),1);
    B = shiftdim(measErrCov(iParSet,1:nStatesKF,1:nStatesKF),1);
    kalmanGain(iParSet,1:nStatesKF,1:nStatesKF) = A*measOperator'*...
         inv(measOperator*A*measOperator' + B);
end
