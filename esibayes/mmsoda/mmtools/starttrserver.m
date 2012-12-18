function starttrserver()

if ~(exist('mpisize','var')==1)
    whoami()
end
if ~(exist('verbosity','var')==1)
    getverbosity();
end

diedworkers=0;
nworkers=mpisize-1;
taskcounter=0;
resultcounter=0;
pending=0;

while true

    str=sprintf('%03d - Waiting for a message...',mpirank);
    disp(str)
    message=receivevar;

    switch message.cmd
        case 'stop'
            str=sprintf('%03d - Stopping of the task-result server has been requested by %03d.',mpirank,message.source);
            disp(str)
            str=sprintf('%03d - Number of pending: %d',mpirank,pending);
            disp(str)
            break % out of the enclosing while loop

        case 'puttask'
            str=sprintf('%03d - Received a task from %03d.',mpirank,message.source);
            disp(str)
            taskcounter=taskcounter+1;
            trpool(taskcounter).task=message.task;
            trpool(taskcounter).result=0;
            trpool(taskcounter).status=1;
            trpool(taskcounter).owner=0;

        case 'putresult'
            str=sprintf('%03d - Received a result from %03d.',mpirank,message.source);
            disp(str)
            for iTask=1:taskcounter
                if trpool(iTask).status==2
                    if trpool(iTask).owner==message.source
                        trpool(iTask).owner=0;
                        trpool(iTask).status=3;
                        trpool(iTask).result=message.result;
                        pending=pending-1;
                        resultcounter=resultcounter+1;
                        break % out of the enclosing for loop
                    end
                end
            end

        case 'gettask'
            str=sprintf('%03d - Task request received from %03d.',mpirank,message.source);
            disp(str)
            taskWasSent=false;
            % Give requester first available task
            for iTask=1:taskcounter
                if trpool(iTask).status==1
                    nmessage.cmd='ok';
                    nmessage.source=0;
                    nmessage.task=trpool(iTask).task;
                    trpool(iTask).status=2;
                    trpool(iTask).owner=message.source;
                    pending=pending+1;
                    taskWasSent=true;
                    str=sprintf('%03d - Task sent to %03d.',mpirank,message.source);
                    disp(str)
                    break % out of the enclosing for loop
                end
            end

            if ~taskWasSent
                %if pending>0
                    % If no free task available and more than one tasks pending, send wait
                    nmessage.cmd='wait';
                    nmessage.source=0;

                %elseif pending==0 && taskcounter>0
                    %% If no free task available and no more tasks pending, finish
                    %nmessage.cmd='die';
                    %nmessage.source=0;
                    %diedworkers=diedworkers+1;
                    %sendvar(message.source,nmessage);
                %else
                    %str=sprintf('%03d - There are no pending tasks.',mpirank);
                    %disp(str)
                %end
            end
            sendvar(message.source,nmessage);

        otherwise
            str=sprintf('%03d - ERROR: Received a strange message - exiting.',mpirank);
            disp(str)
            break % out of the enclosing while loop

    end % case message.cmd

    if diedworkers==nworkers
        str=sprintf('%03d - All workers are dead.',mpirank);
        disp(str)
        break
    end

end % while true

save('trserver.mat','trpool');





