function objScore = calcLikelihood(conf,constants,modelOutput,parVec)


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


mmsodaUnpack()

nStatesKF = conf.nStatesKF;
nPrior = conf.nPrior;
nMembers = conf.nMembers;
nObs = (conf.nPrior-1) * conf.nStatesKF;

obs = repmat(obsState(1:nStatesKF,2:nPrior),[1,1,nMembers]);
sim = modelOutput(1:nStatesKF,2:nPrior,1:nMembers);

ensembleMeanErr = mean(obs-sim,3);


ssr = sum(ensembleMeanErr(:).^2);

objScore = -(1/2) * nObs * log(ssr);



