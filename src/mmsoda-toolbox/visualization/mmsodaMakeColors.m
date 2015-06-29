function colorList = mmsodaMakeColors(conf)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaMakeColorList.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


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


nSequences = conf.nCompl;


defaultColors = [0,0,1;...
    0,0.5,0;
    1,0,0;...
    1,0.5,0;...
    1,0.9,0;...
    0.5882,0.7216,0.1804;...
    0,1,1;...
    1,0,1;...
    0.7529,0.7529,0.7529;...
    0.1490,0.5333,0.7176];

nDefaultColors = size(defaultColors,1);

if nSequences>nDefaultColors
    cVec = linspace(0.1,0.9,ceil((nSequences-nDefaultColors)^(1/3)));
    extraColors = mmsodaAllComb(cVec,cVec,cVec);
else
    extraColors=[];
end


colorList =[defaultColors;extraColors];