% Interpolate the simulated Population and Resources to the times
% at which measurements are available against which to compare the
% simulations:
PopSimI = interp1(tSim,PopSim,tMeas);
ResSimI = interp1(tSim,ResSim,tMeas);

% For each data series, calculate the absolute error:
ErrPop = abs(PopSimI-PopMeas);
ErrRes = abs(ResSimI-ResMeas);

if Extra.argOutIsErr
    % For the optimization, use the weighting factor 'Extra.popWeight' 
    % to calculate a weighted error:
    OUT = Extra.popWeight*ErrPop+(1-Extra.popWeight)*ErrRes;
else
    % Or, for the post-optimization part, output the time series of
    % Population and Resources:
    OUT = [PopSim,ResSim];
end
