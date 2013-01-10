
if exist('conf','var')==1
    % this script is called by runmpirankOtherFun
else
    % this script is the main program
    pause(15)
end

confFile = './results/conf.mat';
constantsFile = './data/constants.mat';

if exist(confFile,'file')==2
    conf = load(confFile);
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

        msg = gettask();
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

            runcounter=runcounter+1;
            sumrun=sumrun+toc(timer);

            putresult(bundle);
        end % if

    end % while

else % if conf.executeInParallel

    bundle = msg; % this is a memory-efficient way of
    clear msg     % renaming a variable

    bundle = sodaProcessBundle(conf,constants,bundle);


end % if conf.executeInParallel






