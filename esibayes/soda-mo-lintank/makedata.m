function makedata()

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


R = 50;
simWaterLevel(1,1) = 45;
simQ(1,1) = NaN;
modeStr = 'inv';
timeStep = 1;
timeVec=[0:timeStep:30];
nTimes = numel(timeVec);

for iTime=2:nTimes

    timeNow = timeVec(iTime);

    switch modeStr
        case 'fwd'
            if timeNow == 20
                simWaterLevel(1,iTime-1) = simWaterLevel(1,iTime-1) *1.30;
            end
        case 'inv'
        otherwise
        end
    simQ(1,iTime) = simWaterLevel(1,iTime-1)*-(1/R);
    simWaterLevel(1,iTime) = simWaterLevel(1,iTime-1) + simQ(1,iTime)*timeStep;
end

obsQ = simQ;
obsWaterLevel = simWaterLevel;
obsTime = timeVec;

figure
subplot(2,1,1)
plot(obsTime,obsWaterLevel,'-b.');
subplot(2,1,2)
plot(obsTime-0.5*timeStep,obsQ,'-.b')


save('./data/obs.mat','-mat','obsWaterLevel','obsTime','obsQ','timeStep')
