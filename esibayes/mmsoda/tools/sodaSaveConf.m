function sodaSaveConf()

varList = evalin('caller','whos');
nVars = numel(varList);

authorizedOptions = sodaVerifyFieldNames([],'return');

saveList = {};

for iVar=1:nVars
    varName = varList(iVar).name;
    if any(strcmp(varName,authorizedOptions))
        saveList{end+1} = varName;
    else
        warning(['Variable ''',varName,''' is not a valid configuration variable.'])
    end
end


evalin('caller',['save(''./results/conf.mat'',',sprintf('''%s'',',...
    saveList{1:end-1}),sprintf('''%s''',saveList{end}),');'])

