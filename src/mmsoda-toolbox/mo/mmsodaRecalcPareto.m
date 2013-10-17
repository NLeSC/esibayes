function [sequences,complexes,propChildren] = mmsodaRecalcPareto(conf,sequences,complexes,propChildren)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaRecalcPareto.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% At this point we have objScores for sequences, complexes and
% propChildren. Now let's make a list that has all the
% objScores together so that we can re-calculate the
% pareto scores.

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


oldSeq = sequences;
oldCompl = complexes;
oldChildren = propChildren;

objScores = [];
for iCompl=1:conf.nCompl
    objScores = [objScores;...
                 sequences(:,conf.llCols,iCompl);...
                 complexes(:,conf.llCols,iCompl);...
              propChildren(:,conf.llCols,iCompl)];
end

% recalc the Pareto scores:
paretoScores = -mmsodaCalcPareto(objScores,conf.paretoMethod);


% redistribute the new pareto scores back into the original variables:
nRowsSeq = size(sequences,1);
nRowsCompl = size(complexes,1);
nRowsChildren = size(propChildren,1);

rowStart = 1;
rowEnd = nRowsSeq;

for iCompl=1:conf.nCompl
    sequences(1:nRowsSeq,conf.paretoCol,iCompl) = paretoScores(rowStart:rowEnd,1);
    rowStart = rowEnd + 1;
    rowEnd = rowStart + nRowsCompl - 1;

    complexes(1:nRowsCompl,conf.paretoCol,iCompl) = paretoScores(rowStart:rowEnd,1);
    rowStart = rowEnd + 1;
    rowEnd = rowStart + nRowsChildren - 1;

    propChildren(1:nRowsChildren,conf.paretoCol,iCompl) = paretoScores(rowStart:rowEnd,1);
    rowStart = rowEnd + 1;
    rowEnd = rowStart + nRowsSeq - 1;
end


newSeq = sequences;
newCompl = complexes;
newChildren = propChildren;

notTheParetoCol = [1:conf.paretoCol-1,conf.paretoCol+1];

if isequal(oldSeq(:,notTheParetoCol),newSeq(:,notTheParetoCol))&&...
        isequal(oldCompl(:,notTheParetoCol),newCompl(:,notTheParetoCol))&&...
        isequal(oldChildren(:,notTheParetoCol),newChildren(:,notTheParetoCol))
    % all ok
else
    error('something''s wrong')
end






