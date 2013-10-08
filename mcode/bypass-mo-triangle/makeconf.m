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

% define what kind of run this will be ('bypass', 'scemua', 'reset' , or 'soda')
modeStr = 'bypass';
% define the objective function name
objCallStrs = {'objectivefun1','objectivefun2','objectivefun3'};
% define the name of the parameters for each parameter
parNames = {'theta1','theta2'};
% set the lower limit on the parameter space for each parameter
parSpaceLoBound = [0.0, 0.0];
% set the higher limit on the parameter space for each parameter
parSpaceHiBound = [1.0, 1.0];
% define the number of complexes
nCompl = 5;
% define the number of samples used for the burn-in
nSamples = 20*nCompl;
% define the maximum number of parameter space samples
nModelEvalsMax = nSamples+200*(1/5)*nSamples;
% specify if soda should visualize the results as they become available (requires X forwarding over ssh)
doPlot = true;
% specify how the parameter space is sampled ('stratified', 'stratified random'), useful for making imagescs of sensitivity
sampleDrawMode = 'stratified';
startFromUniform = true;
drawInterval = 10;
realPartOnly = true;


save('./results/conf.mat')

