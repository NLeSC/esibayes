function mmsodaOpenBrowser(url)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaOpenBrowser.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


s = 'browser=';

fid = fopen(fullfile(mmsodaroot,'helper-apps.txt'),'rt');

if fid~=-1

    line='';
    while ~strncmp(line,s,numel(s))
        line = fgetl(fid);
    end
    status = fclose(fid);

    if numel(line)>numel(s)
        
        oldpath = getenv('LD_LIBRARY_PATH');
        newpath = getenv('PATH');
        
        try
            setenv('LD_LIBRARY_PATH',newpath);
            % select the part after 'browser=':
            formatStr = line(numel(s)+1:end);
            % escape any backslashes:
            formatStr = strrep(formatStr,'\','\\');
            % append & to detach the system process from the MATLAB process:
            formatStr = [formatStr,' &'];
            system(sprintf(formatStr,url));
            setenv('LD_LIBRARY_PATH',oldpath);
        catch
            setenv('LD_LIBRARY_PATH',oldpath);
        end
    else
        web(fullfile(mmsodaroot,'html','browser-not-set.html'),'-helpbrowser')
    end

else
    error(['I dont''t see the ''helper-apps.txt'' file in ',mmsodaroot,'. Aborting.'])
end
