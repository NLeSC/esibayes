function m=waitForResults()

if ~(exist('mpisize','var')==1)
    whoami()
end
if ~(exist('verbosity','var')==1)
    getverbosity();
end


message.cmd = 'results';
message.source = mpirank;
if verbosity>=1
    str=sprintf('%03d - mpirank%d asks mpirank0 to send the results when they are available.',mpirank,mpirank);
    disp(str)
end
sendvar(0,message);


while true
    rmessage = receivevar(0);
    if strcmp(rmessage.cmd,'results')
        m = rmessage.trPool;
        break
    else
        pause(5.0)
        if verbosity>=2
            str=sprintf('%03d - mpirank%d is pausing for 5.0 seconds.',mpirank,mpirank);
            disp(str)
        end

    end
end
