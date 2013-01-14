
if exist('conf','var')==1
    % this script is called by runmpirankOtherFun
else
    % this script is the main program
    % pause(15) % for NFS slowness
end

confFile = './results/conf.mat';
constantsFile = './data/constants.mat';

if exist(confFile,'file')==2
    % extra check for NFS slowness:
    fileProps = dir(confFile);
    oneMinute = 1/60*24;
    if now() - datenum(fileProps.date) < oneMinute
%        conf = load(confFile);
        conf = bcastvar(0,0);
    else
        error('Looks like you are using an old version of the SODA configuration file (could be due to NFS slowness).')
    end
    clear oneMinute
    clear fileProps
else
    fprintf('%03d - I don''t see the configuration file...attempting to proceed without it.',mpirank)
end

if exist(constantsFile,'file')==2
    constants = load(constantsFile);
else
    if strcmp(conf.modeStr,'bypass')
        % do nothing
    elseif conf.executeInParallel
        fprintf('%03d - I don''t see the constants file...attempting to proceed without it.',mpirank)
    else
        disp('I don''t see the constants file...attempting to proceed without it.')
    end
    constants = struct([]);
end



sumrun=0;
runcounter=0;


if conf.executeInParallel
    while true

        msg = receivevar(0);
        timer = tic;
        if ischar(msg)
            switch msg
                case 'die'
                    if verbosity>=1
                        str=sprintf('%03d - Server wants me to die.',mpirank);
                        disp(str)
                    end
                    break % out of the enclosing while
                otherwise
                    disp(msg)
            end % switch
        elseif isstruct(msg)

            bundle = msg; % this is a memory-efficient way of
            clear msg     % renaming a variable

            bundle = sodaProcessBundle(conf,constants,bundle);

            sendvar(0,bundle);
        end % if

    end % while

else % if conf.executeInParallel

    bundle = msg; % this is a memory-efficient way of
    clear msg     % renaming a variable

    bundle = sodaProcessBundle(conf,constants,bundle);


end % if conf.executeInParallel






