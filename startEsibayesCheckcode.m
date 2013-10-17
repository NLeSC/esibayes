



addpath(fullfile('src','mmsoda-toolbox'))

fname = 'src/mmsoda-toolbox/mmsoda.m';

msg = checkcode(fname);

nMsgs = numel(msg);

fid = fopen('checkcode.log','wt');

for iMsg=1:nMsgs
    nChars = fprintf(fid,'%s:%d:%d: E1 %s\n',fname,msg(iMsg).line,msg(iMsg).column(1),msg(iMsg).message);
end


fclose(fid);

exit(0)