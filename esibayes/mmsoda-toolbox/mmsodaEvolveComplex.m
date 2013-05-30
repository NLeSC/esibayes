function [curCompl,acceptedChild] = mmsodaEvolveComplex(conf,curCompl,curSeq,propChild)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaEvolveComplex.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
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


% global DEBUG_VAR_Ratio
% global DEBUG_REPLACE_BEST
% global DEBUG_REPLACE_WORST

evalCol = conf.evalCol;
objCol = conf.objCol;

% determine the last iteration in the current sequence:
maxEval = max(curSeq(:,evalCol));
lastEvalFromSeq = curSeq(:,evalCol)==maxEval;

% determine the density of the last iteration in the current sequence:
lastDensFromSeq = curSeq(lastEvalFromSeq,objCol);

% determine the best density in the current complex:
bestEvalRowNumber = randchoose(curCompl(:,conf.objCol)==max(curCompl(:,objCol)));
bestDensFromCompl = curCompl(bestEvalRowNumber,objCol);


% determine the worst density in the current complex:
worstEvalRowNumber = randchoose(curCompl(:,conf.objCol)==min(curCompl(:,objCol)));
worstDensFromCompl = curCompl(worstEvalRowNumber,objCol);

randUniDraw = rand;

% metropolis annealing:
densDiff = propChild(1,objCol) - lastDensFromSeq;  % <-assumes loglikelihoods

% determine the ratio between the best and worst evaluations
% in the current complex (\Gamma^{\itk}):
bestWorstDiff = bestDensFromCompl-worstDensFromCompl;


if densDiff>=log(randUniDraw)

    % replace the best member of the complex with the proposed offspring
    curCompl(bestEvalRowNumber,:) = propChild;
    acceptedChild = propChild;

elseif ((bestWorstDiff > log(conf.thresholdL)) & (lastDensFromSeq > worstDensFromCompl))

    prevChild = [propChild(1,evalCol),curSeq(lastEvalFromSeq,2:end)];
    acceptedChild = prevChild;
    curCompl(worstEvalRowNumber,:) = prevChild;

else

    prevChild = [propChild(1,evalCol),curSeq(lastEvalFromSeq,2:end)];
    acceptedChild = prevChild;

end


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % %        LOCAL FUNCTION     % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %



function rowNumber = randchoose(logiVec)

TMP = randperm(sum(logiVec));
randChoice = TMP(1);
clear TMP
for n=1:numel(logiVec)
    if logiVec(n)
        randChoice=randChoice-1;
    end
    if randChoice==0
        rowNumber = n;
        break
    end
end


