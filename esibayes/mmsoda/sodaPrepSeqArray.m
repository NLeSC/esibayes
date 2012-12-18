function sequences = sodaPrepSeqArray(scemPar,sequences)
%
% <a href="matlab:web(fullfile(scemroot,'html','prepseqarray.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

TMP = repmat(NaN,[scemPar.nOffspringPerCompl,...
                           size(sequences,2),...
                            scemPar.nCompl]);
sequences = cat(1,sequences,TMP);
