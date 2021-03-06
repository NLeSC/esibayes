function paretoScores = mmsodaCalcPareto(objScores,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcPareto.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

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


if isempty(varargin)
    modeStr = 'v';
else
    modeStr = varargin{1}(1);
end

switch modeStr
    case 'g'
        modeStr = 'Goldberg (1989)';
    case 'z'
        modeStr = 'Zitzler & Thiele (1999)';
    case 'v'
        modeStr = 'Vrugt et al. (2003)';
    otherwise
        error('Unrecognized Pareto mode string.')
end


[nPoints,nObjs] = size(objScores);

switch modeStr
    case 'Vrugt et al. (2003)'
        paretoScores = mmsodaCalcPareto(objScores,'g') +...
                       mmsodaCalcPareto(objScores,'z');
        
    case 'Goldberg (1989)'
        
        paretoRank = zeros(nPoints,1);

        while any(paretoRank==0)

            isNonDom(paretoRank==0,1) =...
                ~isdominated(objScores(paretoRank==0,:));
            paretoRank = paretoRank - isNonDom;

        end
        
        paretoScores = paretoRank + -1*min(paretoRank ) + 1;
        
    case 'Zitzler & Thiele (1999)'
        
        paretoScores = zeros(nPoints,1);
        
        isNonDomIO = ~isdominated(objScores)';
        for k=find(isNonDomIO)
            v = [1:k-1,k+1:nPoints];
            X = repmat(objScores(k,:),[nPoints-1,1]);
            Y = objScores(v,:);
            
            paretoScores(k,1) = sum(all(Y>=X,2))/nPoints;
            
        end
        
        isNonDomIO = isNonDomIO';
        tmp = repmat(false,[nPoints,1]);
        for k=1:nPoints
            if isNonDomIO(k)
                continue
            end
            notMe = ~(tmp|[1:nPoints]'==k);

            X = repmat(objScores(k,:),[nPoints,1]);
            Y = objScores;

            IO = all(Y<=X,2) & isNonDomIO & notMe;
            paretoScores(k,1) = 1+sum(paretoScores(IO,1));
        end

    otherwise
        
end
   


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % %  LOCAL FUNCTIONS      % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

function isDom = isdominated(objScores)

nPoints = size(objScores,1);

isDom = repmat(false,[nPoints,1]);

for k = 1:nPoints
    
    X = repmat(objScores(k,:),[nPoints-1,1]);
    
    v = [1:k-1,k+1:nPoints];
    Y = objScores(v,:);
    
    isDom(k,1) = any(all(Y<X,2));
    
end
