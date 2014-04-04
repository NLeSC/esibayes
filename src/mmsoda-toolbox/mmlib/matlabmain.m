function matlabmain(verbosity,savetimings)

% 

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END


% assignin('base','verbosity',verbosity);
% assignin('base','savetimings',savetimings);
% 
% if ~(exist('mpisize','var')==1)
%     whoami()
% end
% 
% 
% envStr = getenv('PBS_JOBID');
% if ~isempty(envStr)
%     tmp = textscan(envStr,'%[^.]');
%     jobidStr = tmp{1}{1};
%     clear tmp
% else
%     jobidStr = '';
% end
% clear envStr
% 
% timing.jobidStr = jobidStr;
% timing.mpirank = mpirank;
% timing.code(1) = uint8(0);
% timing.timer(1) = double(0);
% timing.counter = uint32(0);
% timing.starttime = tic;
% 
% % from "http://stackoverflow.com/questions/12661862/converting-epoch-to-date-in-matlab"
% time_unix = timing.starttime;
% time_reference = datenum('1970', 'yyyy');
% time_matlab = time_reference + double(time_unix) / 8.64e7/1e3;
% time_matlab_string = datestr(time_matlab, 'mmm dd, yyyy HH:MM:SS.FFF');
% timing.starttimeStr = time_matlab_string;
% 
% [~,s] = system('hostname');
% timing.host = s(1:end-1);
% 
% % returned wrong PID! This is the right way (undocumented matlab)
% timing.pid = num2str(feature('GetPid'));
% 
% assignin('base','timing',timing);
% 
% 
% if savetimings == 1
%     
%     envStr = getenv('PBS_O_WORKDIR');
%     if ~isempty(envStr) && ~strcmp(envStr(end),filesep)
%         envStr = [envStr,filesep];
%     end
% 
%     fn=sprintf([envStr,'results/timing_%03d.mat'],mpirank);
%     timing = evalin('base','timing');
%     save(fn,'timing');
% end
% 
% 
% 
% 
% if mpirank == 0
% 
%     % run the MPI server in a while loop as process with mpirank 0
%     try
%         runmpirank0
%         
%     catch err
%         
%         disp(['MPIRANK = ',sprintf('% 3d',mpirank),' says: ',datestr(now,21),' //  An error occurred.'])
% 
%         for iWorker=1:mpisize
%             sendvar(iWorker,'die');
%         end
%         pause(10)
% 
%         rethrow(err)
%         
%     end
% 
%     for iWorker=1:mpisize
%         sendvar(iWorker,'die');
%     end
%     pause(10)
% 
% else
% 
%     % all others are task-receiving processes
%     runmpirankOther
% 
% end
% 
% 
% mpirank
% 
% if savetimings == 1
%     
%     envStr = getenv('PBS_O_WORKDIR');
%     if ~isempty(envStr) && ~strcmp(envStr(end),filesep)
%         envStr = [envStr,filesep];
%     end
% 
%     fn=sprintf([envStr,'results/timing_%03d.mat'],mpirank);
%     timing = evalin('base','timing');
%     save(fn,'timing');
% end


assignin('base','verbosity',verbosity);
assignin('base','savetimings',savetimings);

if ~(exist('mpisize','var')==1)
    whoami()
end

envStr = getenv('PBS_JOBID');
if ~isempty(envStr)
    tmp = textscan(envStr,'%[^.]');
    jobidStr = tmp{1}{1};
    clear tmp
else
    jobidStr = '';
end
clear envStr

timing.jobidStr = jobidStr;
timing.mpirank = mpirank;
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

[~,s] = system('hostname');
timing.host = s(1:end-1);

% returned wrong PID! This is the right way (undocumented matlab)
timing.pid = num2str(feature('GetPid'));

assignin('base','timing',timing);

if mpirank == 0

    % run the MPI server in a while loop as process with mpirank 0
    runmpirank0

    for iWorker=1:(mpisize-1)
        sendvar(iWorker,'die')
    end

else

    % all others are task-receiving processes
    runmpirankOther

end


if savetimings == 1
    str = getenv('PBS_O_WORKDIR');
    if ~isempty(str) && ~strcmp(str(end),filesep)
        str = [str,filesep];
    end
    fn = sprintf([str,'results/timing_%03d.mat'],mpirank);
    timing = evalin('base','timing');
    save(fn,'timing');
end


