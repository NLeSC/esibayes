function whoami()

mpisize = evalin('base','mpisize');
mpirank = evalin('base','mpirank');
mpibuffersize = evalin('base','mpibuffersize');
assignin('caller','mpisize',mpisize);
assignin('caller','mpirank',mpirank);
assignin('caller','mpibuffersize',mpibuffersize);
