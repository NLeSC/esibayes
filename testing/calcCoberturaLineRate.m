function lineRate = calcCoberturaLineRate(profileStruct)


nFunctions = numel(profileStruct.FunctionTable);

for iFunction=1:nFunctions
    
    
    nLines = callstats('file_lines',profileStruct.FunctionTable(iFunction).FileName);
    nLinesCovered = profileStruct.FunctionTable(iFunction).ExecutedLines;
    
    
end

