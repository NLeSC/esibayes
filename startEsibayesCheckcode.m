



addpath(fullfile('src','mmsoda-toolbox'))

fname = 'src/mmsoda-toolbox/mmsoda.m';

msg = checkcode(fname,'-cyc');

nMsgs = numel(msg);

fidLog = fopen('checkcode.log','wt');
fidComplexity = fopen('mccabe-complexity.log','wt');

for iMsg=1:nMsgs
    
    if ~isempty(strfind(msg(iMsg).message,'The McCabe complexity of '))
        nChars = fprintf(fidComplexity,'%s:%d:%d: E1 %s\n',fname,msg(iMsg).line,msg(iMsg).column(1),msg(iMsg).message);
    else
        nChars = fprintf(fidLog,'%s:%d:%d: E1 %s\n',fname,msg(iMsg).line,msg(iMsg).column(1),msg(iMsg).message);
    end
end


fclose(fidLog);
fclose(fidComplexity);

exit(0)