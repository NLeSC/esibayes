
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaVisualization2.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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


mmsodaSubplotScreen(2,4,1,'figureNumber',1001)
clf
mmsodaMargHist(conf,evalResults)

mmsodaSubplotScreen(1,4,2,'figureNumber',1002)
clf
mmsodaPlotGelmanRubin(conf,critGelRub,'view','full')

mmsodaSubplotScreen(2,4,5,'figureNumber',1003)
clf
mmsodaMatrixOfScatter(conf,'eval-obj',sequences,metropolisRejects)

mmsodaSubplotScreen(1,2,2,'figureNumber',1004)
clf
mmsodaPlotSeq(conf,sequences,metropolisRejects,'plotMode','subaxes','checkered',false)

drawnow