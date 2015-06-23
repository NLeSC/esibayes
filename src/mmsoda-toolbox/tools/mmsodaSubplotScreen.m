function varargout = mmsodaSubplotScreen(nRows,nCols,figIndex,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaSubplotScreen.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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



if nargin==0
    nRows = 1;
    nCols = 1;
    figIndex = 1;
end


if isempty(getenv('DISPLAY'))
    disp('There is no display. Aborting visualization.')
    if nargout==1
        varargout = {};
    end
    return
end

screenRect = get(0,'screensize');

f = 0.45;
hw = floor(f*screenRect(3));
hh = floor(f*screenRect(4));
mw = floor(0.5*screenRect(3));
mh = floor(0.5*screenRect(4));
rect = [mw-hw,mh-hh,2*hw,2*hh];
clear f hw hh mw mh


border = [86,9,0,9];

existingFigures = get(0,'children');
figureNumber = 1;
while true
    if ismember(figureNumber,existingFigures)
        figureNumber = figureNumber+1;
    else
        break
    end
end

authorizedOptions ={'rect','border','figureNumber'};

mmsodaParsePairs


curRectWidth = floor(rect(3)/nCols);
curRectHeight = floor(rect(4)/nRows);


colNumber = mod(figIndex-1,nCols)+1;
rowNumber = 1+(figIndex-colNumber)/nCols;

if ~(1<=colNumber && colNumber<=nCols)||...
   ~(1<=rowNumber && rowNumber<=nRows)

    error('Figure number out of bounds.')

end

curRectLeft = rect(1)+((colNumber-1)*curRectWidth)+1;
curRectBottom = rect(2)+(nRows-rowNumber)*curRectHeight+1;


h=figure(figureNumber);
drawnow

set(h,'position',[curRectLeft + border(4),...
                     curRectBottom + border(3),...
                     curRectWidth - border(2) - border(4),...
                     curRectHeight - border(1) - border(3)]);

if nargout==1
    varargout={h};
end


