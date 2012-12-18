function matlabmain(verbosity)

assignin('base','verbosity',verbosity)

if ~(exist('mpisize','var')==1)
    whoami()
end

if mpirank == 0

    % run the MPI server in a while loop as process with mpirank 0
    runmpirank0

elseif mpirank == 1

    % run the task-generating process (i.e. the optimization algorithm)
    runmpirank1

else

    % all others are task-receiving processes
    runmpirankOther

end

try
    sendcounter = evalin('base','sendcounter');
catch
    sendcounter = 0;
end

try
    sumsend = evalin('base','sumsend');
catch
    sumsend = 0;
end

try
    recvcounter = evalin('base','recvcounter');
catch
    recvcounter = 0;
end

try
    sumrecv = evalin('base','sumrecv');
catch
    sumrecv = 0;
end

if ~(exist('sumrun','var')==1)
    sumrun=0;
    runcounter=0;
end

%Statistics of sending / calculating
str = sprintf('%03d - Summary of sending',mpirank);
disp(str)
str = sprintf('%03d - Messages: %9d --- Time: %s',mpirank,sendcounter,sumsend);
disp(str)
str = sprintf('%03d - Summary of receiving',mpirank);
disp(str)
str = sprintf('%03d - Messages: %9d --- Time: %s',mpirank,recvcounter,sumrecv);
disp(str)
str = sprintf('%03d - Summary of tasks',mpirank);
disp(str)
str = sprintf('%03d - Tasks: %9d --- Time: %s',mpirank,runcounter,sumrun);
disp(str)
        
end
