function complexes = mmsodaPartComplexes(conf,evalResults)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPartComplexes.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

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


nCols = size(evalResults,2);
nComplexes = conf.nCompl;
nSamplesPerCompl = conf.nSamplesPerCompl;
nSamples = conf.nSamples;

% sort the entries in 'evalResults' by iteration number (row 1 is iter 1):
A = sortrows(evalResults,-conf.evalCol);
% select the last 'nSamples' entries in 'A': 
B = A(1:nSamples,:);
    
C = sortrows(B,conf.objCol);


complexes = repmat(NaN,[nSamplesPerCompl,nCols,nComplexes]);
for iCompl=1:nComplexes
    complexes(:,:,iCompl) = C(iCompl:nComplexes:nSamples,:);
end


