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


makeRespSurf = true;


% define the objective function name
objCallStr = 'shiftedRosenbrock';
% define the name of the parameters for each parameter
parNames = {'x1','x2'};
% set the lower limit on the parameter space for each parameter
parSpaceLoBound = [60,-100];
% set the higher limit on the parameter space for each parameter
parSpaceHiBound = [100,100];
% define what kind of run this will be ('bypass', 'scemua', 'reset', or 'soda')
modeStr = 'bypass';
% define the number of complexes
nCompl = 5;
% specify if soda should visualize the results as they become available (requires X forwarding over ssh)
doPlot = true;
% specify how the parameter space is sampled ('stratified', 'stratified random'), useful for making imagescs of sensitivity
sampleDrawMode = 'stratified';
if makeRespSurf
    % define the number of samples used for the burn-in
    nSamples = 50*50;
    % define the maximum number of parameter space samples
    nModelEvalsMax = nSamples;
else
    % define the number of samples used for the burn-in
    nSamples = 100;
    % define the maximum number of parameter space samples
    nModelEvalsMax = nSamples+50*(1/5)*nSamples;
end


clear makeRespSurf


save('./results/conf.mat')

