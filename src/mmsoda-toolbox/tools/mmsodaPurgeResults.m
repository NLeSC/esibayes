function mmsodaPurgeResults()
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPurgeResults.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>



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



if ispc
    pwdStr = strrep(pwd,'\','\\');
    filesepStr = strrep(filesep,filesep,['\',filesep]);
else
    pwdStr = pwd;
    filesepStr = filesep;
end

q1.s = ['This will delete all previous results from directory',char(10),...
    pwdStr,filesepStr,'results',filesepStr,'. Do you want to continue?',char(10),...
    '[a]: yes',char(10),...
    ' b : no',char(10),...
    ' c : cancel.',char(10),...
    char(10),...
    'Your answer: '];
q1.validset = {'a','b','c',''};

a1 = ask(q1);
switch a1
    case {'a'}
    case {''}
        fprintf(1,'\ba\n')
    case {'b','c'}
        disp('Aborting.')
    otherwise
end

listing = dir('./results');

nFiles = numel(listing);

exempt = {'conf.mat','readme','README','.gitignore'};

for iFile = 3:nFiles

   fn = listing(iFile).name;
   if ~any(strcmp(fn,exempt))
       delete(fullfile(pwd,'results',fn))
   end

end





function reply = ask(q,varargin)

questionStr = q.s;
validAnswers = q.validset;


replyWasValid = false;

while ~replyWasValid

    disp(char(9))
    disp(char(9))

    reply = input(questionStr,'s');

    replyWasValid = any(strcmp(reply,validAnswers));

    if ~replyWasValid
        disp('Your answer is invalid.')
    end

end

