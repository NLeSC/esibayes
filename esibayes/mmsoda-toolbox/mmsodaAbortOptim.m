function converged = mmsodaAbortOptim(critGelRub,conf)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaAbortOptim.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
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


if size(critGelRub,1)>=conf.nGelRub
    
    A = critGelRub(end-conf.nGelRub+1:end,conf.parCols);
        
    D = max(A,[],1) - min(A,[],1);
    
    
    if all(D < conf.convMaxDiff) &&...
       all(critGelRub(end,conf.parCols)<conf.critGelRubConvd)
        disp('Convergence achieved.')
        converged = true;
    else
        converged = false;
    end    
else
    converged = false;
end


