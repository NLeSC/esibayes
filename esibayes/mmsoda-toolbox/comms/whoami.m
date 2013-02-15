function whoami()

mpisize = evalin('base','mpisize');
mpirank = evalin('base','mpirank');
assignin('caller','mpisize',mpisize);
assignin('caller','mpirank',mpirank);
