function m=gettask()

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(5);
assignin('base','timing',timing);

if ~(exist('mpisize')==1)
    whoami;
end
if ~(exist('verbosity','var')==1)
    getverbosity();
end

message.cmd = 'gettask';
message.source = mpirank;

sendvar(0,message);
receivedwait = false;
while true
    if verbosity>=2
        str = sprintf('%03d - Requesting task from server.',mpirank);
        disp(str)
    end
    rmessage = receivevar(0);
    if (receivedwait)
        timing = evalin('base','timing');
        timing.counter=timing.counter+1;
        timing.timer(timing.counter)=toc(timing.starttime);
        timing.code(timing.counter)=uint8(40);
        assignin('base','timing',timing);
    end
    switch rmessage.cmd
        case 'wait'
            timing = evalin('base','timing');
            timing.counter=timing.counter+1;
            timing.timer(timing.counter)=toc(timing.starttime);
            timing.code(timing.counter)=uint8(39);
            assignin('base','timing',timing);
            receivedwait = true;
        case 'die'
            m='die';
            break
        case 'ok'
            m=rmessage.task;
            break
        otherwise
    end
end

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(6);
assignin('base','timing',timing);

end
