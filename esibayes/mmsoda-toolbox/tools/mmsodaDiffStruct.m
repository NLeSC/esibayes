function structdiff = mmsodaDiffStruct(struct1,struct2,ignoreFields)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaDiffStruct.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% structdiff tells how strcut 2 is different from struct1 using codes
% 3: field in struct2 is not present in struct1
% 4: field value in struct2 deviates from that in struct1

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



% fn1 = fieldnames(struct1)
fn2 = fieldnames(struct2);

nFieldNames2 = numel(fn2);
for iFieldName2 = 1:nFieldNames2
    theFieldName = fn2{iFieldName2};
    if any(strcmp(theFieldName,ignoreFields))
        % do nothing
    else
        if ~isfield(struct1,theFieldName)
            structdiff.(theFieldName) = 3;
        else
            a = struct1.(theFieldName);
            b = struct2.(theFieldName);

            if isnumeric(a) & isnumeric(b)
                if isequal(a(~isnan(a)),b(~isnan(b)))
                    continue
                else
                    structdiff.(theFieldName) = 4;
                end
            end
        end
    end    
end


if exist('structdiff','var')~=1
    structdiff = struct([]);
end





