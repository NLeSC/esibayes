function [sequences,complexes,propChildren] = sodaRecalcPareto(conf,sequences,complexes,propChildren)

% At this point we have objScores for sequences, complexes and
% propChildren. Now let's make a list that has all the
% objScores together so that we can re-calculate the
% pareto scores.

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
paretoScores = -sodaCalcPareto(objScores,conf.paretoMethod);


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






