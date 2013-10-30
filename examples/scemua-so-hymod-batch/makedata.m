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


load('./data/leafriver.mat','numTime','dailyDischarge','dailyPotEvapTrans','dailyPrecip')

wu = 65;
iStart = 1;
iEnd = iStart + wu - 1 + 730;
convFactor = 22.5;

% crudest estimate of sigma ever:
obsQSigma = 0.01;%std(dailyDischarge(1:end-1)-dailyDischarge(2:end));



% fake conf variable:
conf.nOptPars = 5;
conf.parNames = {'cmax','bexp','fQuickFlow','Rs','Rq'};
conf.nStatesKF = 0;
conf.nNOKF = 0;
% conf.namesNOKF = {'output'};
conf.nOutputs = 1;
conf.priorTimes = numTime([iStart,iStart+wu:iEnd]);
conf.modeStr = 'scemua';

% fake constants variable:
constants.wu = wu;
constants.iStart = iStart;
constants.iEnd = iEnd;
constants.convFactor = convFactor;
constants.obsQSigma = obsQSigma;
constants.numTime = numTime;
constants.dailyDischarge = dailyDischarge;
constants.dailyPotEvapTrans =dailyPotEvapTrans;
constants.dailyPrecip = dailyPrecip;



init = [[];NaN];

parVec=[300,0.2,0.3,0.01,0.4];

priorTimes = conf.priorTimes';


modelOutput = hymod_batch(conf,constants,init,parVec,priorTimes);

nPrior = numel(priorTimes);

dailyDischarge = repmat(NaN,size(dailyDischarge));
dailyDischarge(iStart+wu:iEnd) = modelOutput(1,2:nPrior);


save('./data/leafriver-art.mat','dailyDischarge','dailyPotEvapTrans',...
'dailyPrecip','iStart','iEnd','numTime','parVec','priorTimes','conf',...
'modelOutput','init','wu','convFactor','obsQSigma')
























