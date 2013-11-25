function makeconf()

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



load('./data/obs.mat','obsState')

covModelPert = eye(3)*2.0; 
covObsPert = eye(3)*2.0;
initMethodKF = 'reference';
initValuesKF = [1.508870;-1.531271;25.46091];
modeStr = 'soda';
modelName = 'lorenzeq';
objCallStr = 'calcLikelihood'
obsState = obsState;
parNames = {'parSigma','parBeta','parRho'};
parSpaceHiBound = [30,10,50];
parSpaceLoBound = [0,0,0];
priorTimes = [0.00:0.25:40.0]   % was 40.0
stateNamesKF = {'u(1,1)','u(2,1)','u(3,1)'};
stateSpaceHiBound = [ 50, 50, 50];
stateSpaceLoBound = [-50,-50,-50];

nCompl = 5;
nSamples = 50;
nModelEvalsMax = 5000;
walltime = 55/60/24;  
nMembers = 5*3+1;  % rule of thumb: 5 times the number of states plus one
doPlot = false
drawInterval = 0
startFromUniform = true;
saveInterval = 1;
saveEnKFResults = true;

save('./results/conf.mat')

% initMethodNOKF
% initValuesNOKF
% namesNOKF
