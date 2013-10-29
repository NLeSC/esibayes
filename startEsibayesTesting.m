




relativeDirNames = {fullfile('src','mmsoda-toolbox'),...
        fullfile('src','mmsoda-toolbox','comms'),...
        fullfile('src','mmsoda-toolbox','enkf'),...
        fullfile('src','mmsoda-toolbox','mmlib'),...
        fullfile('src','mmsoda-toolbox','mo'),...
        fullfile('src','mmsoda-toolbox','mmlib'),...
        fullfile('src','mmsoda-toolbox','tools'),...
        fullfile('src','mmsoda-toolbox','visualization'),...
        };
    
nDirs = numel(relativeDirNames);

fidLog = fopen('code-quality-metrics/checkcode.log','wt');
fidComplexity = fopen('code-quality-metrics/mccabe-complexity.log','wt');

k = 1;

for iDir=1:nDirs

    relativeDirName = relativeDirNames{iDir};
    
    addpath(fullfile(pwd,relativeDirName))
    
    whatResult = what(fullfile(pwd,relativeDirName));
    
    nFiles = numel(whatResult.m);
    
    for iFile = 1:nFiles
        
        relativeFileName = [relativeDirName,filesep,whatResult.m{iFile}];
        
        fullFileName = [whatResult.path,filesep,whatResult.m{iFile}];
        listOfFilesBeingTested{k} = fullFileName;
        k = k+1;
        
        msg = checkcode(fullFileName,'-cyc');
        
        nMsgs = numel(msg);
        
        for iMsg=1:nMsgs
            
            if ~isempty(strfind(msg(iMsg).message,'The McCabe complexity'))
                nChars = fprintf(fidComplexity,'%s/%s:%d:%d: E1 %s\n',...
                    relativeDirName,...
                    relativeFileName,...
                    msg(iMsg).line,...
                    msg(iMsg).column(1),...
                    msg(iMsg).message);
            else
                nChars = fprintf(fidLog,'%s/%s:%d:%d: E1 %s\n',...
                    relativeDirName,...
                    relativeFileName,...
                    msg(iMsg).line,...
                    msg(iMsg).column(1),...
                    msg(iMsg).message);
            end
        end
        
    end
    clear nFiles
    clear iFile
    
end
clear k
clear fidComplexity
clear fidLog
clear fullFileName
clear whatResult
clear relativeDirName
clear relativeDirNames
clear relativeFileName
clear msg
clear iDir
clear nChars
clear iMsg
clear nDirs
clear nMsgs



try
    
    addpath(fullfile(pwd,'testing','xunit','xunit'))
    addpath(fullfile(pwd,'testing'))

    
    system('rm ./code-quality-metrics/profiler-results/file*.html');
    
    profile clear -nohistory

    runtests('testing/suite','-xmlfile','code-quality-metrics/testreport.xml')
       
    profileStruct = profile('info');
    
    profsave(profileStruct,'code-quality-metrics/profiler-results')
    
    lineRate = calcCoberturaLineRate(profileStruct,listOfFilesBeingTested)
    
    
catch Ex
    fprintf(2, Ex.getReport())
    quit(1)
end
quit(0)





