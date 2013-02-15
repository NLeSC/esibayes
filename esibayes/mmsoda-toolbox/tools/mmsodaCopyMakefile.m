function mmsodaCopyMakefile()
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCopyMakeFile.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


source = fullfile(mmsodaroot,'comms','Makefile.template');
destination = './Makefile';

disp('Copying Makefile...')

copyfile(source,destination);

disp('Copying Makefile...Done.')
