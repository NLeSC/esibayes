function varargout = mmsodaRetrieveEnsembleData(conf,evalNumbers)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaRetrieveEnsembleData.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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

nPrior = conf.nPrior;
nParsets = numel(evalNumbers);
nMembers = conf.nMembers;
if strcmp(conf.modeStr,'scemua')
    nOutputs = conf.nOutputs;
    nanArray = repmat(NaN,[nParsets,nMembers,nOutputs,nPrior]);
    modelOutputs = nanArray;
elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda') 
    nStatesKF = conf.nStatesKF;
    nanArray = repmat(NaN,[nParsets,nMembers,nStatesKF,nPrior]);
    stateValuesKFPrior = nanArray;
    stateValuesKFPert = nanArray;
    stateValuesKFPost = nanArray;
    obsPerturbed = nanArray;
else
end


disp('Retrieving data from file...')
for ip=1:nParsets

    if strcmp(conf.modeStr,'scemua')
        tmp = loadFromFile(conf,evalNumbers(ip),max(evalNumbers));
        modelOutputs(ip,1:nMembers,1:nOutputs,1:nPrior) = tmp;
        
    elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')
        
        [tmp1,tmp2,tmp3,tmp4] = loadFromFile(conf,evalNumbers(ip),max(evalNumbers));
        stateValuesKFPrior(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp1;
        stateValuesKFPert(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp2;
        stateValuesKFPost(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp3;
        obsPerturbed(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp4;
        
    else
    end

end
disp('Retrieving data from file...Done.')

if strcmp(conf.modeStr,'scemua')

    varargout{1} = modelOutputs;

elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')

    varargout{1} = stateValuesKFPrior;
    varargout{2} = stateValuesKFPert;
    varargout{3} = stateValuesKFPost;
    varargout{4} = obsPerturbed;

else
end



function varargout = loadFromFile(conf,iParset,nRows)

if conf.isSingleObjective
    soMoStr = '-so-';
elseif conf.isMultiObjective
    soMoStr = '-mo-';
else
end

start = [1,conf.nSamples+1:conf.nOffspring:nRows];
finish = [conf.nSamples,conf.nSamples+conf.nOffspring:conf.nOffspring:nRows+conf.nOffspring-1];
ix = find((start<=iParset) & (iParset<=finish));
formatStr = ['./results/%s',soMoStr,'results-enkf-evals-%d-%d.mat'];
fn = sprintf(formatStr,conf.modeStr,start(ix),finish(ix));

try
    if strcmp(conf.modeStr,'scemua')
        load(fn,'modelOutputs')
    elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')
        load(fn,'stateValuesKFPrior','stateValuesKFPert','stateValuesKFPost','obsPerturbed')
    else
    end
    
catch err
    warning(sprintf('Error trying to load parameter set %d from ''%s''.',iParset,fn))
    rethrow(err)
end


s = iParset - start(ix) + 1;

if strcmp(conf.modeStr,'scemua')
    
    varargout{1} = modelOutputs(s,:,:,:);
    
elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')

    varargout{1} = stateValuesKFPrior(s,:,:,:);
    varargout{2} = stateValuesKFPert(s,:,:,:);
    varargout{3} = stateValuesKFPost(s,:,:,:);
    varargout{4} = obsPerturbed(s,:,:,:);

else
end
