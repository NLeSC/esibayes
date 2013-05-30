function varargout = mmsodaCalcObjScore(conf,varargin)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcObjScore.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
%

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


% nWorkers = conf.parallel.nWorkers;
evalCol = conf.evalCol;
llCols = conf.llCols;

iSample = 1;
if size(varargin{1},3)>1
    % 'varargin' is 'propChildren'
    propChildren = varargin{1};
    for iCompl=1:conf.nCompl
        for iOffspring = 1:conf.nOffspringPerCompl

            parsets(iSample,:) = propChildren(iOffspring,:,iCompl);
            iSample = iSample + 1;
        end
    end
else
    % 'varargin' is 'evalResults'
    parsets = varargin{1};
end

nParSets = size(parsets,1);
first = parsets(1,evalCol);
last = parsets(nParSets,evalCol);

str = sprintf('Evaluating parameter sets %d-%d',first,last);
elapsed = etime(datevec(now),datevec(conf.optStartTime));
disp(['+',s2ddhhmmss(elapsed),': ',str])

% call the ensemble Kalman Filter:
parsets = mmsodaEnKF(conf,parsets);

% reshape end result if necessary:
iSample = 1;
if size(varargin{1},3)>1
    % 'varargin' is 'propChildren'
    for iCompl=1:conf.nCompl
        for iOffspring = 1:conf.nOffspringPerCompl

            propChildren(iOffspring,:,iCompl) = parsets(iSample,:);
            iSample = iSample + 1;

        end
    end
    varargout{1} = propChildren(:,conf.llCols,:);
else
    % 'varargin' is 'evalResults'
    evalResults = parsets;
    varargout{1} = evalResults(:,llCols);
end






function str = s2ddhhmmss(durationSeconds)

durationDays = durationSeconds/86400;
accForDays = 0;
nDays = floor((durationDays-accForDays)*1);
accForDays = accForDays+nDays*1;
nHours = floor((durationDays-accForDays)*24);
accForDays = accForDays+nHours/24;
nMins = floor((durationDays-accForDays)*24*60);
accForDays = accForDays+nMins/24/60;
nSecs = floor((durationDays-accForDays)*24*60*60);

if durationSeconds<60
    str=sprintf('%02ds',nSecs);
elseif durationSeconds<60*60
    str=sprintf('%02dm %02ds',nMins,nSecs);
elseif durationSeconds<60*60*24
    str=sprintf('%02dh %02dm %02ds',nHours,nMins,nSecs);
else
    str=sprintf('%dd %02dh %02dm %02ds',nDays,nHours,nMins,nSecs);
end
