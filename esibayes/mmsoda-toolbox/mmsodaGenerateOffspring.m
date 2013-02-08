function propChild = mmsodaGenerateOffspring(conf,curCompl,curSeq,iGeneration)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaGenerateOffspring.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%
%


% rename some entries of 'conf' for brevity:
evalCol = conf.evalCol;
parCols = conf.parCols;
objCol =  conf.objCol;


nSamplesPerCompl = conf.nSamplesPerCompl;
% curCompl = sortrows(curCompl,-objCol);
jumpRate = conf.jumpRate;
nOptPars = conf.nOptPars;

% determine the last iteration in the current sequence:
maxEval = max(curSeq(:,evalCol));
lastEvalRow = curSeq(:,evalCol)==maxEval;

% determine which n-dimensional point was calculated last:
lastPointFromSeq = curSeq(lastEvalRow,parCols);

% calculate complex covariance:
covComplex = cov(curCompl(:,parCols));

% calculate the complex average density:
avgComplDens = mean(curCompl(:,objCol));

% calculate the average density for the last X entries in the current
% sequence: (X being equal to the number of entries per complex)
IO = isnan(curSeq(:,1));
curSeqTweak = curSeq;
curSeqTweak(IO) = -1;
TMP = sortrows(curSeqTweak,-evalCol);
avgSeqDens = mean(TMP(1:nSamplesPerCompl,objCol));



% % % % % % % % % % % % % % % % % % % % % % % 
alphak = (avgComplDens-avgSeqDens);
jumpBaseTest = alphak>log(conf.thresholdL);

if jumpBaseTest
    jumpBase = mean(curCompl(:,parCols),1);
else
    jumpBase = lastPointFromSeq;    
end


propPointAccepted = false;

% Vrugt does: jumpDist = randNormDraw*real(sqrtm(jumpRate*covComplex));
jumpDist_TMP = sqrtm(jumpRate^2*covComplex);
if conf.realPartOnly
    jumpDist = real(jumpDist_TMP);
    if ~isreal(jumpDist_TMP)
        warning(sprintf('''jumpDist'' array contains complex numbers in generation %d.',iGeneration))
    end  
else
    jumpDist = jumpDist_TMP;
end
clear jumpDist_TMP


while ~propPointAccepted

    randNormDraw = randn(1,nOptPars);
    
    if any(imag(jumpDist(:))>1e-5)
        error('Imaginary part not equal to zero.')
    else
        propPoint = jumpBase + randNormDraw*jumpDist;
    end

    propPointAccepted = all((conf.parSpaceLoBound(:)<=propPoint(:)) &...
                             (propPoint(:)<=conf.parSpaceHiBound(:)));
end

propChild = repmat(NaN,[1,conf.objCol]);
propChild(1,conf.parCols) = propPoint;
