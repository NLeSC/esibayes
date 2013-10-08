function conf = mmsodaLoadSettings(conf,f)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaLoadSettings.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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



if uimatlab
   [varName,varValue] = textread(f,'%s = %[^\n]');
   for k=1:numel(varName)
       if ~isfield(conf,varName{k})
           eval(['conf.',varName{k},'=',varValue{k},';'])
       end
   end
elseif uioctave
   fid = fopen(f,'r');
   while true
      s = fgetl(fid);
      if s==-1
         break
      end
      varName=sscanf(s,'%s = %*s','C');
      if ~isfield(conf,varName)
          eval(['conf.',s,';']);
          %eval(['conf.',varName,'=',varValue,';'])
      end
   end
elseif isdeployed
   [varName,varValue] = textread(f,'%s = %[^\n]');
   for k=1:numel(varName)
       if ~isfield(conf,varName{k})
           eval(['conf.',varName{k},'=',varValue{k},';'])
       end
   end
else
   disp('Unrecognized UI. Aborting.')
end


