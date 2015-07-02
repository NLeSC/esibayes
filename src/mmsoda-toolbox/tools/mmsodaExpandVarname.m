function varNames = mmsodaExpandVarname(baseName,dims)

    nVectors = numel(dims);
    vectors = cell(1,nVectors);

    formatStr = [baseName,'('];
    for iVector = 1:nVectors
        vectors{iVector} = 1:dims(iVector);

        formatStr = [formatStr,'%d'];                           %#ok<AGROW>
        if iVector < nVectors
            formatStr = [formatStr,','];                        %#ok<AGROW>
        end

    end
    formatStr = [formatStr,')'];

    arr = mmsodaAllComb(vectors{:},'matlab');
    nVars = size(arr,1);
    varNames = cell(1,nVars);
    for iVar = 1:nVars

        varNames{1,iVar} = sprintf(formatStr,arr(iVar,:));

    end

end



