function propChild = mmsodaGenerateOffspring(conf,curCompl,curSeq,iGeneration)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaGenerateOffspring.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%
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

nAttempts = 0;
nAttemptsMax = 1000;
while ~propPointAccepted

    randNormDraw = randn(1,nOptPars);
    
    if any(imag(jumpDist(:))>1e-5)
        error('Imaginary part not equal to zero.')
    else
        propPoint = jumpBase + randNormDraw*jumpDist;
    end

    propPointAccepted = all((conf.parSpaceLoBound(:)<=propPoint(:)) &...
                             (propPoint(:)<=conf.parSpaceHiBound(:)));
                         
    nAttempts = nAttempts + 1;
    if nAttempts > nAttemptsMax
        
        disp('jumpBase')
        disp(jumpBase)
        disp('jumpDist')
        disp(jumpDist)
        disp('covComplex')
        disp(covComplex)
        
        error([mfilename,' says: I tried ',num2str(nAttempts),' times to ',...
            'generate offspring within the valid ',char(10),'parameter space',...
           'but I did not succeed. I printed some variables above that may help you find out why.'])
    end

end

propChild = repmat(NaN,[1,conf.objCol]);
propChild(1,conf.parCols) = propPoint;
