function [curCompl,acceptedChild] = sodaEvolveComplex(conf,curCompl,curSeq,propChild)
%
% <a href="matlab:web(fullfile(sodaroot,'html','sodaEvolveComplex.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
%

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


