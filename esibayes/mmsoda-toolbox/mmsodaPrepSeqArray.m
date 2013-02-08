function sequences = mmsodaPrepSeqArray(conf,sequences)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPrepSeqArray.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

TMP = repmat(NaN,[conf.nOffspringPerCompl,...
                           size(sequences,2),...
                            conf.nCompl]);
sequences = cat(1,sequences,TMP);
