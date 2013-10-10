function bundle = mmsodaProcessBundle(conf,constants,bundle)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaProcessBundle.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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



nTasks = numel(bundle);
nStatesKF = conf.nStatesKF;
nNOKF = conf.nNOKF;
nDASteps = conf.nDASteps;

if strcmp(conf.modeStr,'scemua')
    nOutputs = conf.nOutputs;
end

switch bundle(1).type
    % a bundle of tasks has to be of the same type for this to work:
    case 'model'
        for iTask=1:nTasks
            stateValuesKFOld = bundle(iTask).stateValuesKFPost;
            valuesNOKFOld = bundle(iTask).valuesNOKF;
            parVec = bundle(iTask).parVec;
            priorTimes = bundle(iTask).priorTimes;
            nPrior = numel(priorTimes);

            init = cat(1,stateValuesKFOld,valuesNOKFOld);

            eval(['modelOutput = ',conf.modelName,'(conf,constants,init,parVec,priorTimes);'])


            switch conf.modeStr
                case {'reset','soda'}
                    if ~isequal(size(modelOutput),[conf.nStatesKF + conf.nNOKF,nPrior])
                        error('Model output argument ''modelOutput'' has unexpected size.')
                    end
                    if ~all(isnan(modelOutput(1:nStatesKF,1)))
                        error(['MMSODA expects modelOutput(1:nStatesKF,1) to be NaN.',char(10),'Please adapt ',...
                            char(39),'./model/',conf.modelName,'.m',char(39),' accordingly.'])
                    end
                    bundle(iTask).stateValuesKFPrior(1:nStatesKF,1:nPrior) = modelOutput(1:nStatesKF,1:nPrior);
                    bundle(iTask).valuesNOKF(1:nNOKF,1:nPrior) = modelOutput(nStatesKF+(1:nNOKF),1:nPrior);
                case 'scemua'
                    if ~isequal(size(modelOutput),[conf.nOutputs,conf.nPrior])
                        error('Model output argument ''modelOutput'' has unexpected size.')
                    end
                    % abuse the KFPrior field for storing the model
                    % outputs, even though we're not doing any KF:
                    bundle(iTask).stateValuesKFPrior(1:nOutputs,1:nPrior) = modelOutput(1:nOutputs,1:nPrior);
                    bundle(iTask).valuesNOKF(1:nNOKF,1:nPrior) = NaN;
                otherwise
            end
        end

    case 'objective'
        for iTask=1:nTasks

            if strcmp(conf.modeStr,'bypass')
                modelOutputs = [];
            else
                allStateValuesKFPrior = bundle(iTask).allStateValuesKFPrior;
                allValuesNOKF = bundle(iTask).allValuesNOKF;
                modelOutputs = cat(1,allStateValuesKFPrior,allValuesNOKF);
            end
            parVec = bundle(iTask).parVec;

            if conf.isSingleObjective
                eval(['llScore = ',conf.objCallStr,'(conf,constants,modelOutputs,parVec);'])
                bundle(iTask).llScores = llScore;
            elseif conf.isMultiObjective
                for iObj = 1:conf.nObjs
                    eval(['llScores(1,iObj) = ',conf.objCallStrs{iObj},'(conf,constants,modelOutputs,parVec);'])
                end
                bundle(iTask).llScores = llScores;
            else
            end
        end
    otherwise
        % do nothing
end



