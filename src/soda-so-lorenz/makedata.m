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



conf = [];
constants = [];
init = [1.508870;-1.531271;25.46091];

parVec = [10,8/3,28];

priorTimes = [0:0.25:40.0]  % was 40.0

simState = lorenzeq(conf,constants,init,parVec,priorTimes);

[nRows,nCols] = size(simState);

gaussTerm = randn(nRows,nCols) * sqrt(2.0);

obsState = simState + gaussTerm;


figure
plot3(obsState(1,:),obsState(2,:),obsState(3,:),'.')


save('./data/obs.mat','simState','gaussTerm','obsState')