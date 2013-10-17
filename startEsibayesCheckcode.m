




dirNames = {fullfile('src','mmsoda-toolbox'),...
        fullfile('src','mmsoda-toolbox','comms'),...
        fullfile('src','mmsoda-toolbox','enkf'),...
        fullfile('src','mmsoda-toolbox','mmlib'),...
        fullfile('src','mmsoda-toolbox','mo'),...
        fullfile('src','mmsoda-toolbox','mmlib'),...
        fullfile('src','mmsoda-toolbox','tools'),...
        fullfile('src','mmsoda-toolbox','visualization'),...
        };

    
nDirs = numel(dirNames);


fidLog = fopen('checkcode.log','wt');
fidComplexity = fopen('mccabe-complexity.log','wt');


for iDir=1:nDirs

    dirName = dirNames{iDir};
    
    addpath(dirName);
    
    fnames = what(fullfile(pwd,dirName));
    
    nFiles = numel(fnames.m);
    
    for iFile = 1:nFiles
        
        fname = fnames.m{iFile};
        
        msg = checkcode(fname,'-cyc');
        
        nMsgs = numel(msg);
        
        
        for iMsg=1:nMsgs
            
            if ~isempty(strfind(msg(iMsg).message,'The McCabe complexity'))
                nChars = fprintf(fidComplexity,'%s/%s:%d:%d: E1 %s\n',dirName,fname,msg(iMsg).line,msg(iMsg).column(1),msg(iMsg).message);
            else
                nChars = fprintf(fidLog,'%s/%s:%d:%d: E1 %s\n',dirName,fname,msg(iMsg).line,msg(iMsg).column(1),msg(iMsg).message);
            end
        end
        
    end
    
    rmpath(dirName)
    
    
end
fclose(fidLog);
fclose(fidComplexity);

exit(0)