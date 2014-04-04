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

if strcmp(conf.modeStr,'scemua')
    nOutputs = conf.nOutputs;
end

switch bundle(1).type
    % a bundle of tasks has to be of the same type for this to work:
    case 'model'
        
        % add time stamp for analysis later when running in parallel compiled mode
        if conf.executeInParallel && evalin('base','savetimings')  
            
            timing = evalin('base','timing');
            timing.code(end + 1) = uint8(66);
            timing.timer(end + 1) = toc(timing.starttime);
            timing.counter = timing.counter + 1;
            assignin('base','timing',timing);

        end
        
        for iTask=1:nTasks
            
            parVec = bundle(iTask).parVec;
            priorTimes = bundle(iTask).priorTimes;
            nPrior = numel(priorTimes);
            if strcmp(conf.modeStr,'scemua')
                
                init = [];
                
                eval(['modelOutput = ',conf.modelName,'(conf,constants,init,parVec,priorTimes);'])
                
                if ~isequal(size(modelOutput),[conf.nOutputs,conf.nPrior])
                    error('Model output argument ''modelOutput'' has unexpected size.')
                end
                bundle(iTask).modelOutput(1:nOutputs,1:nPrior) = modelOutput;
                
            elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')
                
                stateValuesKFOld = bundle(iTask).stateValuesKFPost;
                valuesNOKFOld = bundle(iTask).valuesNOKF;
                
                init = cat(1,stateValuesKFOld,valuesNOKFOld);
                
                eval(['modelOutput = ',conf.modelName,'(conf,constants,init,parVec,priorTimes);'])
                
                
                if ~isequal(size(modelOutput),[conf.nStatesKF + conf.nNOKF,nPrior])
                    error('Model output argument ''modelOutput'' has unexpected size.')
                end
                if ~all(isnan(modelOutput(1:conf.nStatesKF,1)))
                    error(['MMSODA expects modelOutput(1:nStatesKF,1) to be NaN.',char(10),'Please adapt ',...
                        char(39),'./model/',conf.modelName,'.m',char(39),' accordingly.'])
                end
                bundle(iTask).stateValuesKFPrior(1:conf.nStatesKF,1:nPrior) = modelOutput(1:conf.nStatesKF,1:nPrior);
                bundle(iTask).valuesNOKF(1:conf.nNOKF,1:nPrior) = modelOutput(conf.nStatesKF+(1:conf.nNOKF),1:nPrior);
            else
            end
        end % for iTask
        
        % add time stamp for analysis later when running in parallel compiled mode
        if conf.executeInParallel && evalin('base','savetimings') 
            
            timing = evalin('base','timing');
            timing.code(end + 1) = uint8(77);
            timing.timer(end + 1) = toc(timing.starttime);
            timing.counter = timing.counter + 1;
            assignin('base','timing',timing);

        end
        
        
    case 'objective'
        
        % add time stamp for analysis later when running in parallel compiled mode
        if conf.executeInParallel && evalin('base','savetimings')
            
            timing = evalin('base','timing');
            timing.code(end + 1) = uint8(88);
            timing.timer(end + 1) = toc(timing.starttime);
            timing.counter = timing.counter + 1;
            assignin('base','timing',timing);

        end
        
        
        for iTask=1:nTasks
            
            if strcmp(conf.modeStr,'bypass') || strcmp(conf.modeStr,'bypass-noopt')
                modelOutputs = [];
            elseif strcmp(conf.modeStr,'scemua')
                modelOutputs = bundle(iTask).modelOutputs;
            elseif strcmp(conf.modeStr,'reset') || strcmp(conf.modeStr,'soda')
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
        
        
        % add time stamp for analysis later when running in parallel compiled mode
        if conf.executeInParallel && evalin('base','savetimings')
            
            timing = evalin('base','timing');
            timing.code(end + 1) = uint8(99);
            timing.timer(end + 1) = toc(timing.starttime);
            timing.counter = timing.counter + 1;
            assignin('base','timing',timing);

        end
        
        
    otherwise
        % do nothing
end



