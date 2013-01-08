function terminateworkers()

if ~(exist('mpisize','var')==1)
    whoami()
end
if ~(exist('verbosity','var')==1)
    getverbosity();
end


message.cmd = 'terminate workers';
message.source = mpirank;

if verbosity>=1
    str=sprintf('%03d - mpirank%d asks mpirank0 to terminate the workers.',mpirank,mpirank);
    disp(str)
end
sendvar(0,message);
