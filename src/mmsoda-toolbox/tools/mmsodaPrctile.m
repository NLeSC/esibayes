function OUT = mmsodaPrctile(IN,prc)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPrctile.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>



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



[nRows,nCols] = size(IN);
x = transpose(100*((1:nRows)-0.5)/nRows);
prc = sort(prc(:));
OUT = repmat(NaN,[numel(prc),nCols]);

for iCol = 1:nCols
    if any(isnan(IN(:,iCol)))
        continue
    end
    y = sort(IN(:,iCol));
    yi = interp1(x,y,prc,'linear');
    yi(prc<min(x)) = min(y);
    yi(prc>max(x)) = max(y);

    OUT(:,iCol) = yi;

end
