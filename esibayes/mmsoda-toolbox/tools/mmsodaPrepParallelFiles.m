function mmsodaPrepParallelFiles()
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPrepParallelFiles.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% copy the Makefile from the mmsoda root directory to the current
% directory:
mmsodaCopyMakefile()

% ask a bunch of questions and write the job script according to the
% answers:
mmsodaWriteJobscript()
