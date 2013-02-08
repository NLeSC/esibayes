function runCondition = mmsodaContinue(conf,nModelEvals)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaContinue.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

if isinf(conf.optEndTime)
    runCondition = nModelEvals < conf.nModelEvalsMax && ~conf.converged;
else
    runCondition = nModelEvals < conf.nModelEvalsMax &&...
                   ~conf.converged &&...
                   now<conf.optEndTime;
end
