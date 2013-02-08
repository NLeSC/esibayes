function metropolisRejects = mmsodaPrepRejArray(conf,metropolisRejects)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPrepRejArray.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

% re-use the mmsodaPrepSeqArray function for preparing the rejects array:
metropolisRejects = mmsodaPrepSeqArray(conf,metropolisRejects);