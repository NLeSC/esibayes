function matlabmain(verbosity,savetimings)

assignin('base','verbosity',verbosity);

if ~(exist('mpisize','var')==1)
    whoami()
end

timing.code(1) = uint8(0);
timing.timer(1) = double(0);
timing.counter = uint32(0);
timing.starttime = tic;

% from "http://stackoverflow.com/questions/12661862/converting-epoch-to-date-in-matlab"
time_unix = timing.starttime; 
time_reference = datenum('1970', 'yyyy');
time_matlab = time_reference + double(time_unix) / 8.64e7/1e3;
time_matlab_string = datestr(time_matlab, 'mmm dd, yyyy HH:MM:SS.FFF');
timing.starttimeStr = time_matlab_string;

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

if savetimings == 1
    fn=sprintf('./results/timing_%03d.mat',mpirank);
    timing = evalin('base','timing');
    save(fn,'timing');
end
