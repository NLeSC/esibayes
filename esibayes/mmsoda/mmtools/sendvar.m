function sendvar(destination,myvar)

if ~(exist('mpisize','var')==1)
    whoami()
end

if ~(exist('source','var')==1)
    source=-1;
end

timing = evalin('base','timing');
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(3);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(31);
tmp=hlp_serialize(myvar);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(32);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(33);
mm_send(destination,tmp);
timing.counter=timing.counter+1;
timing.timer(timing.counter)=toc(timing.starttime);
timing.code(timing.counter)=uint8(34);
assignin('base','timing',timing);

end
