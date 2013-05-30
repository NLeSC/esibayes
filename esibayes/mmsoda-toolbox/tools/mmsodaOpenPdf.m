function mmsodaOpenPdf(url)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaOpenPdf.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% % 

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END



s = 'pdfviewer=';

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
            % select the part after 'pdfviewer=':
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
        web(fullfile(mmsodaroot,'html','pdfviewer-not-set.html'),'-helpbrowser')
    end

else
    error(['I dont''t see the ''helper-apps.txt'' file in ',mmsodaroot,'. Aborting.'])
end
