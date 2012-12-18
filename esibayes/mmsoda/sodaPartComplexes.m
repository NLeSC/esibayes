function complexes = conftComplexes(conf,evalResults)
%
% <a href="matlab:web(fullfile(scemroot,'html','partcomplexes.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

nCols = size(evalResults,2);
nComplexes = conf.nCompl;
nSamplesPerCompl = conf.nSamplesPerCompl;
nSamples = conf.nSamples;

% sort the entries in 'evalResults' by iteration number (row 1 is iter 1):
A = sortrows(evalResults,-conf.evalCol);
% select the last 'nSamples' entries in 'A': 
B = A(1:nSamples,:);
    
C = sortrows(B,conf.objCol);


complexes = repmat(NaN,[nSamplesPerCompl,nCols,nComplexes]);
for iCompl=1:nComplexes
    complexes(:,:,iCompl) = C(iCompl:nComplexes:nSamples,:);
end


