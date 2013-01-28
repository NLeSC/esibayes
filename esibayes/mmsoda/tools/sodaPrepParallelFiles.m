function sodaPrepParallelFiles()

% copy the Makefile from the mmsoda root directory to the current
% directory:
sodaCopyMakefile()

% ask a bunch of questions and write the job script according to the
% answers:
sodaWriteJobscript()
