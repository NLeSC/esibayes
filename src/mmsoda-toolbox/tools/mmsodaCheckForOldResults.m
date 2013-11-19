function mmsodaCheckForOldResults(conf)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCheckForOldResults.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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




% check if X-Y-tempstate.mat is for the right X-Y
% check if X-Y-results.mat is for the right X-Y
% check if X-Y-results-enkf-Z-Z.mat is for the right X-Y
% check if X-Y-results-enkf-Z-Z.mat has the right sequence of Z
% check if there aren't any old timings files


listing = dir('./results');

nFiles = numel(listing);

exempt = {'conf.mat','conf-out.mat','.gitignore','readme','README'};
standardout = {'jobscript-mmsoda.pbs.e','jobscript-mmsoda.pbs.o'};

throwErr = false;


if ~conf.startFromUniform

    if conf.isSingleObjective
        soMoStr = 'so';
    elseif conf.isMultiObjective
        soMoStr = 'mo';
    else
    end
    load(['./results/',conf.modeStr,'-',soMoStr,'-tempstate.mat'],'evalResults')
    nRows = size(evalResults,1);
end

for iFile = 3:nFiles

   fn = listing(iFile).name;

   if any(strcmp(fn,exempt))
       continue
   end

   if any(strncmp(fn,standardout,22))
       continue
   end

   if ~isempty(strfind(fn,'-results-enkf-evals-'))
       C = textscan(fn,'%[^-]-%[^-]-results-enkf-evals-%d-%d.mat');
       modeStr = C{1};
       soMoStr = C{2};
       zStart = C{3};
       zEnd = C{4};

       if mod(zStart-conf.nSamples,conf.nOffspringPerCompl)~=1
           disp(['Current configuration inconsistent with numbering of existing files (',char(39),fn,char(39),').'])
           throwErr = true;
           break
       end
       if mod(zEnd-conf.nSamples,conf.nOffspringPerCompl)~=0
           disp(['Current configuration inconsistent with numbering of existing files (',char(39),fn,char(39),').'])
           throwErr = true;
           break
       end

       if conf.startFromUniform || (~conf.startFromUniform && zStart > nRows)
           disp(['Won''t overwrite existing results in ''./results'' directory (',char(39),fn,char(39),').'])
           throwErr = true;
           break
       end

   elseif ~isempty(strfind(fn,'-results.mat'))
       C = textscan(fn,'%[^-]-%[^-]-results.mat');
       modeStr = C{1};
       soMoStr = C{2};

   elseif ~isempty(strfind(fn,'-tempstate.mat'))
       C = textscan(fn,'%[^-]-%[^-]-tempstate.mat');
       modeStr = C{1};
       soMoStr = C{2};

   else
       disp(['Unknown file ''',char(39),fn,char(39),''' in ''./results''.'])
       throwErr = true;
       break

   end


   if ~strcmp(conf.modeStr,modeStr{1})
       disp(['''conf.modeStr'' inconsistent with existing files (',char(39),fn,char(39),')'])
       throwErr = true;
       break
   end
   if conf.isSingleObjective && ~strcmp(soMoStr{1},'so')
       disp(['''conf.isSingleObjective'' is true---inconsistent with existing files (',char(39),fn,char(39),')'])
       throwErr = true;
       break
   end
   if conf.isMultiObjective && ~strcmp(soMoStr{1},'mo')
       disp(['''conf.isMultiObjective'' is true---inconsistent with existing files (',char(39),fn,char(39),')'])
       throwErr = true;
       break
   end

   clear modeStr
   clear soMoStr
   clear zStart
   clear zEnd

end


if throwErr

    error(['The results in ''./results'' are inconsistent with the current configuration.',char(10),...
           'You may want to check the documentation on <a href="matlab:doc mmsodaCheckForOldResults">',...
           'mmsodaCheckForOldResults</a> and <a href="matlab:doc mmsodaPurgeResults">mmsodaPurgeResults</a>.'])

end
