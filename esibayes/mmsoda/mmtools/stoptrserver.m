function stoptrserver

if ~(exist('mpisize','var')==1)
    whoami()
end
if ~(exist('verbosity','var')==1)
    getverbosity();
end


if verbosity>=1
    str=sprintf('%03d - Request for stopping task-result server.',mpirank);
    disp(str)
end
message.source=mpirank;
message.cmd='stop';
sendvar(0,message);

