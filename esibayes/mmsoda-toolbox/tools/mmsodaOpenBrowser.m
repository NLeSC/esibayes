function mmsodaOpenBrowser(url)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaOpenBrowser.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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



disp(['Function ''',mfilename,''' is looking up the ''browser='' information',char(10),...
    'to open the web page in an external browser. If unsuccessful, you need to edit',char(10),...
    '''',fullfile(mmsodaroot,'helper-apps.txt'),'''.',char(10),...
    'See also <a href="matlab:doc ',mfilename,'">doc ',mfilename,'</a>.'])



s = 'browser=';
showOnErr = 'browser-not-set.html';


fid = fopen(fullfile(mmsodaroot,'helper-apps.txt'),'rt');


try
    if fid~=-1

        line='';
        while ~strncmp(line,s,numel(s))
            line = fgetl(fid);
            if ~ischar(line)
                status = fclose(fid);
                error(['No entry found for ''',s,'''.'])
            end
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
                [status,tmp] = system(sprintf(formatStr,url));
                if status~=0
                    web(fullfile(mmsodaroot,'html',showOnErr),'-helpbrowser')
                end
                setenv('LD_LIBRARY_PATH',oldpath);
            catch
                setenv('LD_LIBRARY_PATH',oldpath);
            end
        else
            web(fullfile(mmsodaroot,'html',showOnErr),'-helpbrowser')
        end

    else
        error(['I dont''t see the ''helper-apps.txt'' file in ',mmsodaroot,'. Aborting.'])
    end
catch
    web(fullfile(mmsodaroot,'html',showOnErr),'-helpbrowser')
end


