function converged = sodaAbortOptim(critGelRub,conf)
%
% <a href="matlab:web(fullfile(sodaroot,'html','sodaAbortOptim.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%


if size(critGelRub,1)>=conf.nGelRub
    
    A = critGelRub(end-conf.nGelRub+1:end,conf.parCols);
        
    D = max(A,[],1) - min(A,[],1);
    
    
    if all(D < conf.convMaxDiff) &&...
       all(critGelRub(end,conf.parCols)<conf.critGelRubConvd)
        disp('Convergence achieved.')
        converged = true;
    else
        converged = false;
    end    
else
    converged = false;
end


