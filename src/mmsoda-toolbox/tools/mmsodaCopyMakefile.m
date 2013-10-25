function mmsodaCopyMakefile()
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCopyMakeFile.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
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



source = fullfile(mmsodaroot,'comms','Makefile.template');
destination = 'Makefile';

disp('Creating Makefile...')


makefileStr = '';
fid = fopen(source,'rt');
while true
    tline = fgets(fid);
    if ~ischar(tline)
        break
    end
    makefileStr = [makefileStr,tline];
end
fclose(fid);


 
fid = fopen(destination,'wt');
fprintf(fid,'%s',sprintf(makefileStr,mmsodaroot));
fclose(fid);



disp('Creating Makefile...Done.')
