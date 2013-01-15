function sequences = sodaPrepSeqArray(conf,sequences)
%
% <a href="matlab:web(fullfile(sodaroot,'html','sodaPrepSeqArray.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

TMP = repmat(NaN,[conf.nOffspringPerCompl,...
                           size(sequences,2),...
                            conf.nCompl]);
sequences = cat(1,sequences,TMP);
