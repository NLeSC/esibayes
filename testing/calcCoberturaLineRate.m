function lineRate = calcCoberturaLineRate(profileStruct,listOfFilesBeingTested)


nFunctions = numel(profileStruct.FunctionTable);

nLines = repmat(NaN,[nFunctions,1]);
nLinesCovered = repmat(NaN,[nFunctions,1]);

for iFunction=1:nFunctions
    
    fname = profileStruct.FunctionTable(iFunction).FileName;
    
    if any(strcmp(fname,listOfFilesBeingTested))
        tmp = profileStruct.FunctionTable(iFunction).ExecutedLines;
        nLinesCovered(iFunction) = numel(tmp(:,1)');
        nLines(iFunction) = numel(callstats('file_lines',fname));
    else
        nLinesCovered(iFunction) = 0;        
        nLines(iFunction) = 0;
    end
    
end


nLinesTotal = sum(nLines);
nLinesCoveredTotal = sum(nLinesCovered);
lineRate = nLinesCoveredTotal/nLinesTotal;
