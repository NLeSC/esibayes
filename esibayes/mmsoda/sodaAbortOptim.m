function converged = sodaAbortOptim(critGelRub,scemPar)
%
% <a href="matlab:web(fullfile(scemroot,'html','abortoptim.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%


if size(critGelRub,1)>=scemPar.nGelRub
    
    A = critGelRub(end-scemPar.nGelRub+1:end,scemPar.parCols);
        
    D = max(A,[],1) - min(A,[],1);
    
    
    if all(D < scemPar.convMaxDiff) &&...
       all(critGelRub(end,scemPar.parCols)<scemPar.critGelRubConvd)
        disp('Convergence achieved.')
        converged = true;
    else
        converged = false;
    end    
else
    converged = false;
end


