function conf = mmsodaAdjustNumberOfComplexes(conf)

if isdeployed
    
    if conf.startFromUniform
        
        if conf.nComplAdjustWhenDeployed

            oldValues = [conf.nCompl,...
                         conf.nSamples,...
                         conf.nOffspringFraction,...
                         conf.nOffspring,...
                         conf.nModelEvalsMax];
            
                     
            nSamplesPerCompl = conf.nSamples / conf.nCompl;
            
            % get mpisize, mpirank
            whoami

            nComplIncrement = (mpisize - conf.nOffspring) / (conf.nOffspring/conf.nCompl);
            
            conf.nCompl     = conf.nCompl + nComplIncrement;
            conf.nSamples   = conf.nCompl * nSamplesPerCompl;
            conf.nOffspring = conf.nSamples * conf.nOffspringFraction;

            newValues = [conf.nCompl,...
                         conf.nSamples,...
                         conf.nOffspringFraction,...
                         conf.nOffspring,...
                         conf.nModelEvalsMax];
            
            if isequal(oldValues,newValues)
                
                disp('The number of complexes was not adjusted.')
                
            else

                fprintf(1,'\n')
                str = ['MMSODA has added ',num2str(nComplIncrement),' complex'];
                if nComplIncrement == 1
                    str = [str,'.'];
                else
                    str = [str,'es.'];
                end
                disp(str)
                clear str
                
                names = {'nCompl','nSamples','nOffspringFraction','nOffspring','nModelEvalsMax'};
                fmStrs = {'% 6d','%6d','%6.2f','%6d','%6g'};
                for iName = 1:numel(names)
                    
                    str = sprintf('%20s',names{iName});
                    str = [str, ' = ',sprintf(fmStrs{iName},oldValues(iName))];
                    if oldValues(iName)==newValues(iName)
                        str = [str,'    (no adjustment)'];
                    else
                        str = [str,' -> ',num2str(newValues(iName),fmStrs{iName})];
                    end
                    disp(str)
                    
                end
                fprintf(1,'\n')
            end
            
        else
            % do nothing
        end
        
    else
        % resuming from an earlier run --get nComp from whatever was 
        % calculated before
    end
    
else
    
    % do nothing
    
end




