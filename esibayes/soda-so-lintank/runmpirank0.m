

nWorkers = mpisize-1;
diedWorkers = repmat(false,[1,nWorkers]);
waitingWorkers = repmat(false,[1,nWorkers]);
taskCounter = 0;
resultCounter = 0;
nPending = 0;
allWorkersAreDead = all(diedWorkers);
trPool = struct([]);
sendResultsWhenReady = false;

while ~allWorkersAreDead

    if verbosity>=2
        str=sprintf('%03d - Waiting for a message...',mpirank);
        disp(str)
    end
    timing = evalin('base','timing');
    timing.counter=timing.counter+1;
    timing.code(timing.counter)=uint8(41);
    assignin('base','timing',timing);
    message = receivevar;
    timing = evalin('base','timing');
    timing.counter=timing.counter+1;
    timing.code(timing.counter)=uint8(42);
    assignin('base','timing',timing);

    switch message.cmd

        case 'puttask'
            if verbosity>=2
                str=sprintf('%03d - Received a task from %03d.',mpirank,message.source);
                disp(str)
            end
            taskCounter = taskCounter+1;
            trPool(taskCounter).task = message.task;
            trPool(taskCounter).status = 1;
            trPool(taskCounter).owner = 0;
            nPending = nPending+1;
            if (any(waitingWorkers))
                for iWorker=1:nWorkers
                    if (waitingWorkers(iWorker))
                        clear nmessage
                        nmessage.cmd = 'ok';
                        nmessage.source = 0;
                        nmessage.task = trPool(taskCounter).task;
                        trPool(taskCounter).status = 2;
                        trPool(taskCounter).owner = iWorker;
                        if verbosity>=2
                            str = sprintf('%03d - Task sent to (waiting) %03d.',mpirank,iWorker);
                            disp(str)
                        end
                        waitingWorkers(iWorker)=false;
                        sendvar(iWorker,nmessage);
                        break % out of for-loop
                    end
                end
            end

        case 'putresult'
            if verbosity>=2
                str=sprintf('%03d - Received a result from %03d.',mpirank,message.source);
                disp(str)
            end
            for iTask=1:taskCounter
                if trPool(iTask).status==2
                    if trPool(iTask).owner==message.source
                        trPool(iTask).owner = 0;
                        trPool(iTask).status = 3;
                        trPool(iTask).result = message.result;

                        % save bandwidth:
                        trPool(iTask).task = [];

                        nPending = nPending-1;
                        resultCounter = resultCounter+1;
                    end
                end
            end

        case 'gettask'
            if verbosity>=2
                str = sprintf('%03d - Task request received from %03d.',mpirank,message.source);
                disp(str)
            end
            taskWasSent = false;
            % Give requester first available task
            for iTask = resultCounter+1:taskCounter
                if trPool(iTask).status==1
                    clear nmessage
                    nmessage.cmd = 'ok';
                    nmessage.source = 0;
                    nmessage.task = trPool(iTask).task;
                    trPool(iTask).status = 2;
                    trPool(iTask).owner = message.source;
                    if verbosity>=2
                        str = sprintf('%03d - Task sent to %03d.',mpirank,message.source);
                        disp(str)
                    end
                    sendvar(message.source,nmessage);
                    taskWasSent = true;
                    break
                end % trPool(iTask).status==1
            end % iTask=1:taskCounter

            if ~taskWasSent
                % Workers have been assigned to all tasks, tell the requester to wait
                clear nmessage
                nmessage.cmd = 'wait';
                nmessage.source = 0;
                sendvar(message.source,nmessage);
                waitingWorkers(message.source) = true;
                if verbosity>=2
                    str = sprintf('%03d - There are no tasks, mpirank%d tells mpirank%d to wait.',mpirank,mpirank,message.source);
                    disp(str)
                end
            end % ~taskWasSent

        case 'stop'
            if verbosity>=2
                str = sprintf('%03d - Stopping of the task-result server has been requested by %03d.',mpirank,message.source);
                disp(str)
                str = sprintf('%03d - Number of pending: %d',mpirank,nPending);
                disp(str)
            end

            break

        case 'terminate workers'
            if verbosity>=1
                str = sprintf('%03d - The task generating process %d asked me to terminate all workers.',mpirank,message.source);
                disp(str)
            end
            clear nmessage
            nmessage.cmd = 'die';
            nmessage.source = 0;
            for iWorker = 2:nWorkers
                diedWorkers(iWorker) = true;
                sendvar(iWorker,nmessage);
            end

            pause(10)

            if verbosity>=1
                str = sprintf('%03d - Stopping the task-result server.',mpirank);
                disp(str)
            end

            if verbosity>=1
                str = sprintf('%03d - Exiting.',mpirank);
                disp(str)
            end

            break

        case 'results'
            sendResultsWhenReady = true;

        otherwise
            if verbosity>=1
                str=sprintf('%03d - ERROR: Received a strange message - exiting.',mpirank);
                disp(str)
            end

    end % case message.cmd

    if sendResultsWhenReady && nPending == 0
        clear nmessage
        %save('trserver.mat','trPool');

        trPool = rmfield(trPool,'task');

        nmessage.cmd = 'results';
        nmessage.source = 0;
        nmessage.trPool = trPool;
        sendvar(1,nmessage);
        sendResultsWhenReady = false;


        trPool = struct([]);
        taskCounter = 0;
        resultCounter = 0;
    end

    allWorkersAreDead = all(diedWorkers);
    if allWorkersAreDead
        if verbosity>=1
            str=sprintf('%03d - All workers are dead.',mpirank);
            disp(str)
        end
    end

end % while true
