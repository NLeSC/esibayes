function innovations = mmsodaLoadInnovationsFromFile(conf,varargin)

    iParset = 1;
    iMember = 1;
    authorizedOptions = {...
                         'iParset',...
                         'iMember',...
                        };                                      %#ok<NASGU>

    parsePairs()

    if conf.isSingleObjective
        somoStr = 'so';
    elseif conf.isMultiObjective
        somoStr = 'mo';
    else
    end

    files = dir(['results/',conf.modeStr,'-',somoStr,'-results-enkf-evals-*-*.mat']);
    nFiles = numel(files);
    theFormatStr = [conf.modeStr,'-',somoStr,'-results-enkf-evals-%d-%d.mat'];
    for iFile = 1:nFiles
        
        theFilename = files(iFile).name;
        C = textscan(theFilename,theFormatStr,1);
        iParsetFirst = C{1};
        iParsetLast  = C{2};
        
        if iParsetFirst <= iParset && iParset <= iParsetLast
            load(fullfile('results',theFilename),'stateValuesKFInn')
            break
        end
        
    end 
    
    innovations = shiftdim(stateValuesKFInn(iParset,iMember,:,:),2);       %#ok<NODEF>
    
    if ~isequal(size(innovations),[conf.nStatesKF,conf.nDASteps])
        error('Unexpected size. Aborting.')
    end

end