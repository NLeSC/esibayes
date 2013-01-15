function makeconstants()


% load the artificial data
load('./data/leafriver-art.mat','numTime','dailyDischarge',...
    'dailyPotEvapTrans','dailyPrecip','wu','iStart','iEnd','convFactor',...
    'obsQSigma')



save('./data/constants.mat')
