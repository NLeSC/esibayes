function modelOutput  = lintank(conf,constants,init,parVec,priorTimes)

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

nPriorChunk = numel(priorTimes);
nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;

for k=2:nPriorChunk

    timeNow = priorTimes(k-1);
    switch modeStr
        case 'fwd'
            if timeNow == 20
                simWaterLevel = simWaterLevel *1.30;
            end
        case 'inv'
        otherwise
    end
    

    Q = simWaterLevel*-(1/R);
    simWaterLevel = simWaterLevel + Q*timeStep;

    stateValuesKFNew(1:nStatesKF,k) = simWaterLevel;
    valuesNOKFNew(1:nNOKF,k) = [rand;Q];
    
end



modelOutput = [stateValuesKFNew;valuesNOKFNew];