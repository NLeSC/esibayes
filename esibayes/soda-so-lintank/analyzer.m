clf

reply = input('Please enter the lower boundary [secs] ','s');
if isempty(reply)
    reply='0.0';
end
min_time=str2num(reply);

reply = input('Please enter the upper boundary [secs] ','s');
if isempty(reply)
    reply='10.0';
end
max_time=str2num(reply);

counter=0;
anotherfile=true;
while anotherfile
    fn=sprintf('timing_%03d.mat',counter)
    try
        load(fn);
    catch
        anotherfile=false;
    end
    
    if anotherfile
        waiting=0;
        counter=counter+1;
        for i=1:timing.counter
            if (timing.timer(i)>min_time) && (timing.timer(i)<max_time)
                if (mod(timing.code(i),2)==1)
%search for ending of block
                    for j=i+1:timing.counter
                        if (timing.code(j)==(timing.code(i)+1))
                            endtime=timing.timer(j);
                            if (endtime>max_time)
                                endtime=max_time;
                            end
                            break;
                        end
                    end
                end
                height=0.0;
                color=[1.0,1.0,1.0];
                switch timing.code(i)
                    case 1
                        height=0.8;
                        color=[0.3,0.5,0.7];
                            
                    case 3
                        height=0.8;
                        color=[0.7,0.5,0.3];
                            
                    case 5
                        height=1.0;
                        color=[1.0,0.0,0.0];
                            
                    case 7
                        height=1.0;
                        color=[0.0,1.0,0.0];
                        
                    case 9
                        height=1.0;
                        color=[0.0,0.0,1.0];
                            
                    case 31
                        height=0.6;
                        color=[1.0,1.0,0.0];
                        
                    case 33
                        height=0.6;
                        color=[1.0,0.0,1.0];
                            
                    case 35
                        height=0.6;
                        switch waiting
                            case 0
                                color=[0.8,0.8,0.8];
                            
                            case 1
                                color=[0.6,0.6,0.6];
                            
                            case 2
                                color=[0.4,0.4,0.4];
                        end
                            
                    case 37
                        height=0.6;
                        color=[1.0,1.0,1.0];
                        
                    case 39
                        height=0.0;
                        waiting=1;
                    
                    case 40
                        height=0.0;
                        waiting=0;
                        
                    case 41
                        height=0.0;
                        waiting=2;
                    
                    case 42
                        height=0.0;
                        waiting=0;
                        
                end
                if (height>0)&&(endtime>timing.timer(i))
                    rectangle('Position',[timing.timer(i),1.5*counter+(1-height)/2,endtime-timing.timer(i),height],'FaceColor',color);
                end
            end
        end
        clear('timing');
    end
end