function m=putresult(result)

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(9);
assignin('base','timing',timing);

if ~(exist('mpisize','var')==1)
    whoami()
end
if ~(exist('verbosity','var')==1)
    getverbosity();
end


if ~exist('result','var')
    if verbosity>=1
        str=sprintf('%03d - putresult requires a result structure as argument.',mpirank);
        disp(str)
    end
    m='error';
else
    message.cmd = 'putresult';
    message.source = mpirank;
    message.reply = 'none';
    message.result = result;
    message.status = 2;
    if verbosity>=2
        str = sprintf('%03d - Sending results to server.',mpirank);
        disp(str)
    end
    sendvar(0,message);
    m = 'ok';
end

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(10);
assignin('base','timing',timing);

