function m=receivevar(source)

if ~(exist('mpisize','var')==1)
    whoami()
end

if ~(exist('source','var')==1)
    source=-1;
end

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(1);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(35);
tmp=mm_receive(source);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(36);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(37);
m=hlp_deserialize(tmp);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(38);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(2);
assignin('base','timing',timing);

