function mmsodaSaveConf()
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaSaveConf.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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


varList = evalin('caller','whos');
nVars = numel(varList);

authorizedOptions = mmsodaVerifyFieldNames([],'return');

saveList = {};

for iVar=1:nVars
    varName = varList(iVar).name;
    if any(strcmp(varName,authorizedOptions))
        saveList{end+1} = varName;
    else
        warning(['Variable ''',varName,''' is not a valid configuration variable.'])
    end
end


evalin('caller',['save(''./results/conf.mat'',',sprintf('''%s'',',...
    saveList{1:end-1}),sprintf('''%s''',saveList{end}),');'])

