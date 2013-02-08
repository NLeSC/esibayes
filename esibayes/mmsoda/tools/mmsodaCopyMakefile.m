function sodaCopyMakefile()


source = fullfile(sodaroot,'mmlib','Makefile');
destination = '.';

disp('Copying Makefile...')

copyfile(source,destination);

disp('Copying Makefile...Done.')
