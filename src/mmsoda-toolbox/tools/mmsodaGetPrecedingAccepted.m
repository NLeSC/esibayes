function iEvalOut = mmsodaGetPrecedingAccepted(conf,metropolisRejects,iEvalIn)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaGetPrecedingAccepted.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
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



if nargin == 0
    fn = [mfilename('fullpath'),'.m'];
    fid = fopen(fn,'r');
    line = fgetl(fid);
    fclose(fid);
    disp('% Usage is: ')
    disp(['% ',line])
    disp('%')
    return
end

% this function checks if a given iEvalIn row in evalResults was accepted
% or not. If it was, then iEvalOut=iEvalIn. Else, the function returns
% the row number in evalResults that contains the last parameter set that
% was accepted.

if numel(iEvalIn)>1
    error('Input argument ''iEvalIn'' should be scalar.')
end

x = mod(iEvalIn-1-conf.nSamples,conf.nOffspring)+1;
iCompl = ceil(conf.nCompl*x./conf.nOffspring);
tmp = metropolisRejects(:,conf.evalCol,iCompl) == iEvalIn;
if ~any(tmp)
    iEvalOut = iEvalIn;
else
    iMyGen = (iEvalIn-conf.nSamples-x)/conf.nOffspring;


    for iGen = iMyGen:-1:0

        iEval = conf.nSamples + (iGen-1)*conf.nOffspring + iCompl*conf.nOffspringPerCompl;

        tmp = metropolisRejects(:,conf.evalCol,iCompl) == iEval;
        if ~any(tmp)
            iEvalOut = iEval;
            break
        end

    end
end




