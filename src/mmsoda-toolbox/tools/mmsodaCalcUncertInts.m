function varargout = mmsodaCalcUncertInts(conf,evalResults,metropolisRejects,prc,evalNumbers,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcUncertaintyIntervals.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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

replaceRejected = true;
iState = 1;

authorizedOptions = {'replaceRejected','iState'};

mmsodaParsePairs

prc = prc(:);

nPrior = conf.nPrior;
includeBest = nargout == 3;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
if includeBest
    [bestEvals,bestRows] = mmsodaBestEval(conf,evalResults);
    try
        [stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed] =...
            mmsodaRetrieveEnsembleData(conf,bestRows);
        if numel(bestRows) == 1
            bestY = [permute(stateValuesKFPrior(1,1,1,1:nPrior),[4,3,2,1])';...
                 permute(stateValuesKFPost(1,1,1,1:nPrior),[4,3,2,1])'];
        else
            disp('There are multiple bests')
        end

    catch
        disp('The data for the best model run could not be retrieved from file.')
        bestY = repmat(NaN,[numel(bestRows),nPrior]);
    end
end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

nParsets = numel(evalNumbers);
nMembers = conf.nMembers;

for k=1:nParsets
    if replaceRejected
        evalNumbers(k) = mmsodaGetPrecedingAccepted(conf,metropolisRejects,evalNumbers(k));
    end
end

[stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed] =...
    mmsodaRetrieveEnsembleData(conf,evalNumbers);

allModelOutputs = repmat(NaN,[nParsets*nMembers,nPrior*2]);

X = repmat(conf.priorTimes,[2,1]);
X = transpose(X(:));
for ip=1:nParsets
    for im=1:nMembers

        Y = [permute(stateValuesKFPrior(ip,im,iState,1:nPrior),[4,3,2,1])';...
            permute(stateValuesKFPost(ip,im,iState,1:nPrior),[4,3,2,1])'];

        k = (ip-1)*nMembers + im;
        allModelOutputs(k,:) = Y(:);
    end

end

percentiles = mmsodaPrctile(allModelOutputs,[2.5,50,97.5]);



if nargout == 2

    varargout{1} = X;
    varargout{2} = percentiles;

elseif nargout == 3

    varargout{1} = X;
    varargout{2} = percentiles;
    varargout{3} = transpose(bestY(:));

else
end



