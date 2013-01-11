function matlabmain(verbosity)

assignin('base','verbosity',verbosity);

if ~(exist('mpisize','var')==1)
    whoami()
end

timing.code(1)=uint8(0);
timing.timer(1)=double(0);
timing.counter=uint32(0);
timing.starttime=tic;
assignin('base','timing',timing);

if mpirank == 0

    % run the MPI server in a while loop as process with mpirank 0
    runmpirank1

%elseif mpirank == 1
%
%    % run the task-generating process (i.e. the optimization algorithm)
%    runmpirank1
%
else

    % all others are task-receiving processes
    runmpirankOther

end

fn=sprintf('timing_%03d.mat',mpirank);
timing = evalin('base','timing');
save(fn,'timing');
