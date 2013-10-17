function uDraw = mmsodaUnifRandDraw(conf,drawMode)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaUnifRandDraw.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
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


% This code has been revised by JHS2007
switch drawMode
    case 'stateSpace'
       
        nStates = conf.nStates;
        nMembers = conf.nEnsembleMembers;
        stateSpaceHiBound = conf.stateSpaceHiBound;
        stateSpaceLoBound = conf.stateSpaceLoBound;
        
        stateSpaceRange = stateSpaceHiBound-stateSpaceLoBound;
        
        rangeWidth = repmat(stateSpaceRange,[1,1,nMembers]);
        rangeMin = repmat(stateSpaceLoBound,[1,1,nMembers]);
        uDraw = rangeMin + rand(1,nStates,nMembers).*rangeWidth;
        
    case 'parSpace'
        nOptPars = conf.nOptPars;
        nSamples = conf.nSamples;
        parSpaceHiBound = conf.parSpaceHiBound;
        parSpaceLoBound = conf.parSpaceLoBound;

        rangeWidth = repmat(parSpaceHiBound-parSpaceLoBound,[nSamples,1]);
        rangeMin = repmat(parSpaceLoBound,[nSamples,1]);
        uDraw = rangeMin + rand(nSamples,nOptPars).*rangeWidth;
    otherwise
        error('unknown drawmode.')
        
end
