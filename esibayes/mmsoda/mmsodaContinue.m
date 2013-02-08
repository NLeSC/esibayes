function runCondition = sodaContinue(conf,nModelEvals)
%
% <a href="matlab:web(fullfile(sodaroot,'html','sodaContinue.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

if isinf(conf.optEndTime)
    runCondition = nModelEvals < conf.nModelEvalsMax && ~conf.converged;
else
    runCondition = nModelEvals < conf.nModelEvalsMax &&...
                   ~conf.converged &&...
                   now<conf.optEndTime;
end
