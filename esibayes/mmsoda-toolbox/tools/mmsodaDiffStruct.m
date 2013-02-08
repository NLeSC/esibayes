function structdiff = mmsodaDiffStruct(struct1,struct2,ignoreFields)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaDiffStruct.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

% structdiff tells how strcut 2 is different from struct1 using codes
% 3: field in struct2 is not present in struct1
% 4: field value in struct2 deviates from that in struct1


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





