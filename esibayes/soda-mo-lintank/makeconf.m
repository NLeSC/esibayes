function makeconf(obsTime,obsWaterLevel)

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



% load the observations that were just created by 'makedata'
load('./data/obs.mat','obsWaterLevel','obsTime')


% define what kind of run this will be ('scemua', 'reset' , or 'soda')
modeStr = 'soda';
% define the model name
modelName = 'lintank';
% define the objective function names (needs at least 2 because of MO, can be the same though)
objCallStrs = {'rmse_flow','rmse_state'};
% optionally define the TeX labels for use in visualization
objTexNames = {'RMSE_{flow}','RMSE_{state}'};
% define the name of the parameters for each parameter
parNames = {'R'};
% set the lower limit on the parameter space for each parameter
parSpaceLoBound = [10];
% set the higher limit on the parameter space for each parameter
parSpaceHiBound = [1000];
% define the name of the variable that is going to be updated by the EnKF
stateNamesKF = {'simWaterLevel'};
% set the lower limit on the state space for each state
stateSpaceLoBound = [0];
% set the higher limit on the state space for each state
stateSpaceHiBound = [55];
% define the names of additional variables that are unique to each member
namesNOKF = {'output1','Q'};
% define the variable that contains the time steps for which data assimilation will be performed
priorTimes = obsTime;
% define the variable that contains the observations made at time = obsTime
obsState = obsWaterLevel;
% define the error model characteristics for the model perturbations as used by the EnKF (currently only white noise is supported)
covModelPert = 0.25;
% define the error model characteristics for the observation perturbations as used by the EnKF (currently only white noise is supported)
covObsPert = 0.005;
% define the method initializing the values of the EnKF states (currently only 'reference' is supported)
initMethodKF = 'reference';
% define the values of the EnKF states for each state
initValuesKF = 45;
% define the method initializing the values of the additional variables (currently only 'reference' is supported)
initMethodNOKF = 'reference';
% define the values of the additional variables for each state
initValuesNOKF = [1.2;NaN];
% define the number of complexes
nCompl = 5;
% define the number of samples used for the burn-in
nSamples = 10*nCompl;
% define the maximum number of parameter space samples
nModelEvalsMax = nSamples+100*(1/5)*nSamples;
% define the number of ensemble members to use in the EnKF
nMembers = 6;
% specify if soda should visualize the results as they become available (requires X forwarding over ssh)
doPlot = true;
% specify how the parameter space is sampled ('stratified', 'stratified random'), useful for making imagescs of sensitivity
sampleDrawMode = 'stratified';
startFromUniform = true;

saveInterval = 0;
saveEnKFResults = false;



if doPlot
   figure
   plot(obsTime,obsWaterLevel,'-mo')
   set(gca,'xlim',[obsTime(1),obsTime(end)],'ylim',[0,max(obsWaterLevel*1.1)])
   drawnow
end


clear obsTime
clear obsWaterLevel

save('./results/conf.mat')











