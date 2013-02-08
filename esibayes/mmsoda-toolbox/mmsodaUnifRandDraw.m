function uDraw = mmsodaUnifRandDraw(conf,drawMode)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaUnifRandDraw.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

% This code has been revised by JHS2007
switch drawMode
    case 'stateSpace'
       
        nStates = conf.nStates;
        nMembers = conf.nEnsembleMembers;
        stateSpaceHiBound = conf.stateSpaceHiBound;
        stateSpaceLoBound = conf.stateSpaceLoBound;
        
        stateSpaceRange = stateSpaceHiBound-stateSpaceLoBound;
        
        rangeWidth = repmat(stateSpaceRange,[1,1,nMembers]);
        rangeMin = repmat(stateSpaceLoBound,[1,1,nMembers]);
        uDraw = rangeMin + rand(1,nStates,nMembers).*rangeWidth;
        
    case 'parSpace'
        nOptPars = conf.nOptPars;
        nSamples = conf.nSamples;
        parSpaceHiBound = conf.parSpaceHiBound;
        parSpaceLoBound = conf.parSpaceLoBound;

        rangeWidth = repmat(parSpaceHiBound-parSpaceLoBound,[nSamples,1]);
        rangeMin = repmat(parSpaceLoBound,[nSamples,1]);
        uDraw = rangeMin + rand(nSamples,nOptPars).*rangeWidth;
    otherwise
        error('unknown drawmode.')
        
end
