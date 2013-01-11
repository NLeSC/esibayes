function varargout = sodaCalcObjScore(conf,varargin)

%
% <a href="matlab:web(fullfile(sodaroot,'html','calcobjscore.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
%

% nWorkers = conf.parallel.nWorkers;
evalCol = conf.evalCol;
llCols = conf.llCols;

iSample = 1;
if size(varargin{1},3)>1
    % 'varargin' is 'propChildren'
    propChildren = varargin{1};
    for iCompl=1:conf.nCompl
        for iOffspring = 1:conf.nOffspringPerCompl

            parsets(iSample,:) = propChildren(iOffspring,:,iCompl);
            iSample = iSample + 1;
        end
    end
else
    % 'varargin' is 'evalResults'
    parsets = varargin{1};
end

nParSets = size(parsets,1);
first = parsets(1,evalCol);
last = parsets(nParSets,evalCol);
str = sprintf('Evaluating parameter sets %d-%d',first,last);
disp(str)

% call the ensemble Kalman Filter:
parsets = sodaEnKF(conf,parsets);

% reshape end result if necessary:
iSample = 1;
if size(varargin{1},3)>1
    % 'varargin' is 'propChildren'
    for iCompl=1:conf.nCompl
        for iOffspring = 1:conf.nOffspringPerCompl

            propChildren(iOffspring,:,iCompl) = parsets(iSample,:);
            iSample = iSample + 1;

        end
    end
    varargout{1} = propChildren(:,conf.llCols,:);
else
    % 'varargin' is 'evalResults'
    evalResults = parsets;
    varargout{1} = evalResults(:,llCols);
end






