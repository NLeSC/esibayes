% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaUnpack.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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


calledByModel__ =  exist('priorTimes','var')==1;

if calledByModel__
    
    nStatesKF = conf.nStatesKF;
    nNOKF = conf.nNOKF;
    switch conf.modeStr
        case 'scemua'
            nOutputs = conf.nOutputs;
        case {'reset','soda'} 
            nOutputs = nStatesKF + nNOKF;
        otherwise
    end
    nPriorChunk = numel(priorTimes);

    % prepare the output arrays with NaNs
    modelOutput = repmat(NaN,[nOutputs,nPriorChunk]);
    clear nPriorChunk
    clear nOutputs


    % map the KF state values to their respective variables
    for iStateKF = 1:nStatesKF
        eval([conf.stateNamesKF{iStateKF},' = init(iStateKF,1);'])
    end
    clear iStateKF
    


    % map the non-KF valuies to their respective variables
    for iNOKF = 1:nNOKF
        eval([conf.namesNOKF{iNOKF},' = init(nStatesKF+iNOKF,1);'])
    end
    clear iNOKF
    clear nNOKF
    clear nStatesKF    

end
clear calledByModel__

% map the parameter values to their respective variables:
for iPar = 1:conf.nOptPars
    eval([conf.parNames{iPar},' = parVec(iPar);'])
end
clear iPar

% map the constants values to their respective variables:
FN__ = fieldnames(constants);
for iConstant__ = 1:size(FN__,1)
    eval([FN__{iConstant__},' = constants.',FN__{iConstant__},';'])
end


clear iConstant__
clear FN__


