




dirNames = {fullfile(pwd,'src','mmsoda-toolbox'),...
        fullfile(pwd,'src','mmsoda-toolbox','comms'),...
        fullfile(pwd,'src','mmsoda-toolbox','enkf'),...
        fullfile(pwd,'src','mmsoda-toolbox','mmlib'),...
        fullfile(pwd,'src','mmsoda-toolbox','mo'),...
        fullfile(pwd,'src','mmsoda-toolbox','mmlib'),...
        fullfile(pwd,'src','mmsoda-toolbox','tools'),...
        fullfile(pwd,'src','mmsoda-toolbox','visualization'),...
        };

    
nDirs = numel(dirNames);


fidLog = fopen('checkcode.log','wt');
fidComplexity = fopen('mccabe-complexity.log','wt');


for iDir=1:nDirs

    dirName = dirNames{iDir};
    
    addpath(dirName);
    
    fnames = what(dirName);
    
    nFiles = numel(fnames.m);
    
    for iFile = 1:nFiles
        
        fname = fnames.m{iFile};
        
        msg = checkcode(fname,'-cyc');
        
        nMsgs = numel(msg);
        
        
        for iMsg=1:nMsgs
            
            if ~isempty(strfind(msg(iMsg).message,'The McCabe complexity of '))
                nChars = fprintf(fidComplexity,'%s:%d:%d: E1 %s\n',fname,msg(iMsg).line,msg(iMsg).column(1),msg(iMsg).message);
            else
                nChars = fprintf(fidLog,'%s:%d:%d: E1 %s\n',fname,msg(iMsg).line,msg(iMsg).column(1),msg(iMsg).message);
            end
        end
        
    end
    
    rmpath(dirName)
    
    
end
fclose(fidLog);
fclose(fidComplexity);

exit(0)