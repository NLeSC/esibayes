function rHatRoot = sodaGelmanRubin(conf,sequences)
%
% <a href="matlab:web(fullfile(scemroot,'html','gelmanrubin.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%
% Based on 7-step prescriptive summary in Gelman and Rubin 1992;
% Statistical Science, Vol. 7, No. 4, p457-472.

parCols = conf.parCols;

% Use only the last X rows from each complex to diminish the effect of the
% starting distribution:

iGeneration = (size(sequences,1)-conf.nSamplesPerCompl)/conf.nOffspringPerCompl;
startAtRow = conf.nSamplesPerCompl +...
                   floor(iGeneration*(1-conf.convUseLastFraction))*...
                   conf.nOffspringPerCompl+1;



if (size(sequences,1)-startAtRow)<10
    startAtRow = 1;
end

n = size(sequences,1)-startAtRow+1;
m = conf.nCompl;

rHatRoot = repmat(NaN,[1,length(parCols)]);

for p=parCols

    complSubSet = reshape(sequences(startAtRow:end,p,1:m),[n,m]);

    seqMeans = mean(complSubSet,1);
    seqMeansRep = repmat(seqMeans,[n,1]);

    seqVars = sum((complSubSet-seqMeansRep).^2,1)./(n-1);

    % Estimate the target distribution mean:
    globMean = mean(complSubSet(:));

    % Calculate the variance between sequence means. Note that
    % 'B_over_n' equals 'var(seqMeans)':
    B_over_n = sum((seqMeans-globMean).^2)./(m-1);

    % Calculate the average of within-sequence variances:
    W = mean(seqVars);

    % Estimate the target distribution variance:
    sigmaHatSquared = ((n-1)/n)*W + B_over_n;

    % Estimate the scale of the approximate Student's t distribution:
    vHat = sigmaHatSquared + B_over_n/m;

    varHatsSquared = var(seqVars);
    
    tmpCovMat = cov([seqVars(:),seqMeans(:).^2]);
    covHatsSquaredxSquared = tmpCovMat(1,2);
    clear tmpCovMat
    
    tmpCovMat = cov([seqVars(:),seqMeans(:)]);
    covHatsSquaredx = tmpCovMat(1,2);
    clear tmpCovMat

    term01 = ((n-1)/n)^2 * (1/m) * varHatsSquared +...
             ((m+1)/(m*n))^2 * (2/(m-1)) * (B_over_n*n)^2;

    switch conf.modeGelRub
        case 'strict'
            % paper actually says: 
            term02 = 2*(((m+1)*(n-1))/(m*n^2))
        case 'loose'
            % vrugt:
            term02 = 2*(((m+1)*(n-1))/(m*n)^2);
        otherwise
            error(['SODA system parameter ',39,'conf.modeGelRub',39,...
                ' should be set ',10,'to either ',39,'strict',39,...
                ' or ',39,'loose',39,'.'])
    end
    
    term03 = (n/m)*(covHatsSquaredxSquared-2*globMean*covHatsSquaredx);

    varHatvHat = term01 + term02 * term03;


    % Calculate the degrees of freedom for the 
    % approximate Student's t distribution:
    df = 2*vHat^2/varHatvHat;

    % Calculate potential scale reduction factor:
    rHatRoot(1,p-conf.parCols(1)+1) = sqrt((vHat/W)*df/(df-2));

end




