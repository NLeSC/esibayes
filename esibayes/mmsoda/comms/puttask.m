function m=puttask(task)

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(7);
assignin('base','timing',timing);

if ~(exist('mpisize','var')==1)
    whoami()
end
if ~(exist('verbosity','var')==1)
    getverbosity()
end

if ~(exist('task','var')==1)
    if verbosity>=1
        str=sprintf('%03d - puttask requires a task structure as argument.',mpirank);
        disp(str)
    end
    m='error';
else
    message.cmd='puttask';
    message.source=mpirank;
    message.task=task;
    if verbosity>=2
        str=sprintf('%03d - Sending task to server.',mpirank);
        disp(str)
    end
    sendvar(0,message);
    m='ok';
end

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(8);
assignin('base','timing',timing);

end
