function varargout = soda(varargin)
% Parallel SCEM-UA, MOSCEM-UA and SODA
%
% <a href="matlab:web(fullfile(sodaroot,'html','soda.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
%
% If you haven't used the SODA documentation before, you need to
% install it by running >> soda --docinstall
% <a href="matlab:soda --docinstall">Install documentation now</a>
%
%
% based on SCEM-UA, MOSCEMUA and SODA algorithms by J.A. Vrugt
%
% Author         : Jurriaan H. Spaaks
% Date           : July 2012
% Matlab release : 2012a on Win7/64 and Octave 3.2 on Lubuntu 12.04 64-bit


if ~isempty(varargin) && ischar(varargin{1})

    sodaInitialize(varargin)

elseif isempty(varargin)

    % display disclaimer:
    disp_disclaimer

    try 
        conf = load('./results/conf.mat');
    catch
        error('I can''t find the *.mat file that holds the SODA configuration.')
    end

    % define whether the run is parallel or sequential
    conf.executeInParallel = isdeployed;
    if conf.executeInParallel
        verbosity = evalin('caller','verbosity');
    end

    % verify the integrity of conf's fieldnames:
    sodaVerifyFieldNames(conf,'check')

    % % These parameters can be derived from the existing settings:
    % Number of parameters to be optimized:
    conf.nOptPars = numel(conf.parNames);
    if any(strcmp(conf.modeStr,{'soda','reset'}))
        conf.nStatesKF = numel(conf.stateNamesKF);
        if ~isfield(conf,'namesNOKF')
            conf.namesNOKF = {};
        end
        conf.nNOKF = numel(conf.namesNOKF);
        conf.nPrior = numel(conf.priorTimes);
        if ~isfield(conf,'assimilate')
            conf.assimilate = repmat(true,[1,conf.nPrior]);
        end
        conf.nDASteps = sum(conf.assimilate);
        conf.obsStateTime = conf.priorTimes(conf.assimilate);
        if ~isfield(conf,'saveEnKFResults')
            conf.saveEnKFResults = true;
        end
    elseif strcmp(conf.modeStr,'scemua')
        conf.nStatesKF = 0;%numel(conf.stateNamesKF);
        conf.nNOKF = numel(conf.namesNOKF);
        conf.nDASteps = 0; % so that you can use the same code as for soda and reset modes
        conf.nPrior = numel(conf.priorTimes);
        if ~isfield(conf,'assimilate')
            conf.assimilate = repmat(false,[1,conf.nPrior]);
        end
        if ~isfield(conf,'saveEnKFResults')
            conf.saveEnKFResults = true;
        end
    elseif strcmp(conf.modeStr,'bypass')
        conf.nStatesKF = 0;
        conf.nNOKF = 0;
        conf.nDASteps = 0;
        conf.nPrior = 0;
    else
        % do nothing 
    end
    % load default settings from file:
    if isfield(conf,'useIniFile')
        fileStr = fullfile(sodaroot,conf.useIniFile);
        conf = sodaLoadSettings(conf,fileStr);
    else
        fileStr = fullfile(sodaroot,'soda-default-settings.ini');
        conf = sodaLoadSettings(conf,fileStr);
    end
    clear fileStr

    % initialize the uniform random generator:
    try
        rand('twister',conf.randSeed);
    catch
        if conf.verboseOutput
            disp(['Using the rand seed method instead of the ',...
                char(10),'default twister method. ',char(10),...
                '<a href="matlab:doc rand">doc rand</a>'])
        end
        rand('seed',conf.randSeed);
    end


    % initialize the Gaussian random generator:
    try
        randn('state',conf.randSeed);
    catch
        if conf.verboseOutput
            disp(['Using the randn state method instead of the ',...
                char(10),'default twister method. ',char(10),...
                '<a href="matlab:doc rand">doc rand</a>'])
        end
        randn('seed',conf.randSeed);
    end



    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % %                                             % % % % % %
    % % % % % %      SODA  INITIALIZATION FINISHED          % % % % % %
    % % % % % %                                             % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


    % check if any inconsistencies can be identified from conf's fields:
    conf = check_input_integrity(conf,nargout);
    checkIfFoldersExist();

    % number of samples per complex:
    conf.nSamplesPerCompl = conf.nSamples/conf.nCompl;

    %number of offspring per complex:
    conf.nOffspringPerCompl = conf.nOffspring/conf.nCompl;

    % Calculate the parameters in the exponential power density function:
%     [conf.cBeta,conf.omegaBeta] = sodaCalcCbWb(conf);


    % Indicate the meaning of each column in 'evalResults':
    if conf.isSingleObjective
        conf.evalCol = 1;                                     % model evaluation counter
        conf.parCols = conf.evalCol+(1:conf.nOptPars);  % model parameters
        conf.llCols = conf.parCols(end)+1;                 % log likelihood
        conf.paretoCol = NaN;                                 % pareto score not defined for single-objective
        conf.objCol = conf.llCols(1);                      % SCEM-UA's decision-mkaing is based on this col
    elseif conf.isMultiObjective
        conf.evalCol = 1;                                     % model evaluation counter
        conf.parCols = conf.evalCol+(1:conf.nOptPars);  % model parameters
        conf.llCols = conf.parCols(end)+(1:conf.nObjs); % log likelihoods
        conf.paretoCol = conf.llCols(end)+1;               % pareto score
        conf.objCol = conf.paretoCol;                      % SCEM-UA's decision-mkaing is based on this col
    else
    end

    if conf.executeInParallel
        % specify the number of workers
        if ~(exist('mpisize','var')==1)
            whoami()
        end
        conf.nWorkers = mpisize-1;
    else
        conf.nWorkers = 1;
    end

    conf.optStartTime = now;

    %initialize the gelman-rubin statistic record:
    critGelRub = [];

    authorizedFieldNames = sodaVerifyFieldNames([],'return');
    saveList = {};
    varList = fieldnames(conf);
    nVars = numel(varList);
    for iVar=1:nVars
        varName = varList{iVar};
        if any(strcmp(varName,authorizedFieldNames))
            saveList{end+1} = varName;
        else
            warning(['Variable ''',varName,''' is not a valid configuration variable.'])
        end
    end
    save('./results/conf.mat','-struct','conf',saveList{:})
    bcastvar(0,conf);
    clear authorizedFieldNames
    clear iVar
    clear nVars
    clear saveList
    clear varName
    clear varList

    sodaStartTime = now;
    if conf.isMultiObjective
        soMoStr = '-mo';
    elseif conf.isSingleObjective
        soMoStr = '-so';
    else
    end
    disp([char(10),upper([conf.modeStr,soMoStr]),' run started on: ',datestr(sodaStartTime,...
        'mmmm dd, yyyy'),' ',datestr(sodaStartTime,'HH:MM:SS')])
    clear s


    if conf.startFromUniform

        switch conf.sampleDrawMode
            case 'stratified random'
                % Startified uniform random sampling of points
                % in parameter space:
                randomDraw = sodaStratRandDraw(conf);
            case 'stratified'
                % Startified sampling of points in parameter space:
                randomDraw = sodaStratDraw(conf);
        end

        evalResults = repmat(NaN,[conf.nSamples,conf.objCol]);
        evalResults(:,conf.evalCol) = (1:conf.nSamples)';
        evalResults(:,conf.parCols) = randomDraw;
        evalResults(:,conf.llCols) = sodaCalcObjScore(conf,evalResults);
        if conf.isMultiObjective
            evalResults(:,conf.paretoCol) = -sodaCalcPareto(evalResults(:,conf.llCols),conf.paretoMethod);
        end

        nModelEvals = size(evalResults,1);

        % partition 'evalResults' into complexes and initialize the sequences:
        complexes = sodaPartComplexes(conf,evalResults);
        sequences = complexes;
        metropolisRejects = repmat(NaN,size(sequences));

    else
        % continue with an earlier run
        thisconf = conf;
        clear conf
        if thisconf.isSingleObjective
            s = 'so';
        else
            s = 'mo';
        end
        load([thisconf.modeStr,'-',s,'-tempstate.mat'],...
            'conf','critGelRub','evalResults','metropolisRejects',...
            'sequences','complexes')

        thatconf = conf;
        
        ignoreFields = {'startFromUniform','nModelEvalsMax','optStartTime',...
                        'saveInterval','verboseOutput','doPlot','executeInParallel',...
                        'saveEnKFResults','drawInterval','optEndTime',...
                        'visualizationCall'};
        if ~isempty(sodaDiffStruct(thisconf,thatconf,ignoreFields))
            error('Configuration is different from last time. Aborting.')
        else
            conf = thisconf;
            clear thisconf
            clear thatconf
            clear ignoreFields
            clear s
        end

        nModelEvals = evalResults(end,1)
        if conf.verboseOutput
            disp([upper(conf.modeStr),' run continues at ',num2str(nModelEvals+1), ' model evaluations.'])
        end


        % temporarily reset the value of 'conf.startFromUniform' in
        % order to invoke an additional test in 'check_input_integrity'
        conf.startFromUniform = true;
        check_input_integrity(conf,nargout)
        % restore the old value
        conf.startFromUniform = false;

    end
    conf = orderfields(conf);
    
    iGeneration  = (size(evalResults,1)-conf.nSamples)/conf.nOffspring;

    if conf.saveInterval>0
        save(['./results/',conf.modeStr,soMoStr,'-tempstate.mat'],'-mat',...
                            'evalResults','critGelRub','sequences','metropolisRejects','conf','complexes')
    end
    if conf.doPlot
        if ~isempty(getenv('DISPLAY'))
            eval(conf.visualizationCall)
        else
            warning('DISPLAY variable not set-- can''t plot anything.')
        end
    end


    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % %                                                         % % % % % %
    % % % % % %            SODA  START OF MAIN LOOP                     % % % % % %
    % % % % % %                                                         % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


    try
        while sodaContinue(conf,nModelEvals)

            propChildren = repmat(NaN,[conf.nOffspringPerCompl,conf.objCol,conf.nCompl]);
            for iCompl=1:conf.nCompl

                % select the current complex:
                curCompl = complexes(:,:,iCompl);

                % select the current sequence:
                curSeq = sequences(:,:,iCompl);

                for iOffspring = 1:conf.nOffspringPerCompl

                    % propose offspring based on statistical properties of the
                    % current complex and sequence:
                    nModelEvals = nModelEvals + 1;
                    propChildren(iOffspring,:,iCompl) = sodaGenerateOffspring(conf,curCompl,curSeq,iGeneration);
                    propChildren(iOffspring,conf.evalCol,iCompl) = nModelEvals;

                end % iOffspring = 1:conf.nOffspringPerCompl

            end % iCompl=1:conf.nCompl

            % calculate objective for unevaluated rows of evalResults:
            propChildren(:,conf.llCols,:) = sodaCalcObjScore(conf,propChildren);

            if conf.isMultiObjective
                % recalculate the global pareto scores based on the objectives
                % scores for all points evaluated so far:
                [sequences,complexes,propChildren] = sodaRecalcPareto(conf,sequences,complexes,propChildren);
            end

            sequences = sodaPrepSeqArray(conf,sequences);
            metropolisRejects = sodaPrepRejArray(conf,metropolisRejects);

            for iCompl=1:conf.nCompl

                % select the current complex:
                curCompl = complexes(:,:,iCompl);

                % select the current sequence:
                curSeq = sequences(:,:,iCompl);

                for iOffspring = 1:conf.nOffspringPerCompl

                    % evolve the current complex by accepting the proposed child...
                    % or by re-accepting the last child from the current sequence:
                    propChild = propChildren(iOffspring,:,iCompl);

                    [curCompl,acceptedChild] = sodaEvolveComplex(conf,curCompl,curSeq,propChild);

                    rNumber = size(sequences,1)-conf.nOffspringPerCompl+iOffspring;

                    % add the accepted child to the 'sequences' array:
                    sequences(rNumber,:,iCompl) = acceptedChild;

                    % add the accepted child to the 'evalResults' array:
                    evalResults = [evalResults;acceptedChild];

                    if isequal(propChild,acceptedChild)
                        metropolisRejects(rNumber,:,iCompl) = repmat(NaN,[1,conf.objCol]);
                    else
                        metropolisRejects(rNumber,:,iCompl) = propChild;
                    end
                end % iOffspring = 1:conf.nOffspringPerCompl

            end % iCompl=1:conf.nCompl



            % partition 'evalResults' into complexes:
            complexes = sodaPartComplexes(conf,evalResults);

            iGeneration = (nModelEvals-conf.nSamples)/conf.nOffspring;

            %determine the Gelman-Rubin scale reduction (convergence) statistic:
            critGelRub(iGeneration,:) = [nModelEvals,sodaGelmanRubin(conf,sequences)];

            % determine whether all parameters meet the Gelman-Rubin scale
            % reduction criterion
            conf.converged = sodaAbortOptim(critGelRub,conf);

            if conf.doPlot &&...
                (mod(iGeneration,conf.drawInterval)==0)
                if ~isempty(getenv('DISPLAY'))
                    eval(conf.visualizationCall)
                else
                    warning('DISPLAY variable not set-- can''t plot anything.')
                end
            end



            if mod(iGeneration,conf.saveInterval)==0

                save(['./results/',conf.modeStr,soMoStr,'-tempstate.mat'],'-mat',...
                            'evalResults','critGelRub','sequences','metropolisRejects','conf','complexes')

            end %  mod(iGeneration,...


        end % sodaContinue(conf,nModelEvals)

        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        % % % % % %                                             % % % % % %
        % % % % % %          SODA END OF MAIN LOOP              % % % % % %
        % % % % % %                                             % % % % % %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
        % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

        conf.optEndTime = now;
        nDaysPerParSet = (conf.optEndTime-conf.optStartTime)/size(evalResults,1);
        if nDaysPerParSet<(1/(24*60))
            % measure in seconds
            v = nDaysPerParSet*24*60*60;
            u = 'seconds';
        elseif nDaysPerParSet<(1/24)
            % measure in minutes
            v = nDaysPerParSet*24*60;
            u = 'minutes';
        elseif nDaysPerParSet<1
            % measure in hours
            v = nDaysPerParSet*24;
            u = 'hours';
        end
        conf.avgWalltimePerParSet = {v,u};

        disp([upper([conf.modeStr,soMoStr]),' run completed on: ',datestr(conf.optEndTime,...
            'mmmm dd, yyyy'),' ',datestr(conf.optEndTime,'HH:MM:SS')])

        varargout = prepOutput(nargout,evalResults,critGelRub,sequences,metropolisRejects,conf);


        % save the results
        save(['./results/',conf.modeStr,soMoStr,'-results.mat'],...
             'evalResults','critGelRub','sequences','metropolisRejects','conf','complexes')


        if conf.executeInParallel
            for iWorker = 1:conf.nWorkers
                sendvar(iWorker,'die');
            end
        end


        durationDays = (conf.optEndTime-conf.optStartTime);
        accForDays = 0;
        nDays = floor((durationDays-accForDays)*1);
        accForDays = accForDays+nDays*1;
        nHours = floor((durationDays-accForDays)*24);
        accForDays = accForDays+nHours/24;
        nMins = floor((durationDays-accForDays)*24*60);
        accForDays = accForDays+nMins/24/60;
        nSecs = floor((durationDays-accForDays)*24*60*60);
        str=sprintf('The run took %dd %dh %dm %ds.',nDays,nHours,nMins,nSecs);
        disp(str)




    catch

        % there is still a minor bug here somewhere, since the software
        % does not seem to ever reach the catch part.

        disp([lasterr,char(10),...
            upper([conf.modeStr,soMoStr]),': Attempting to return the results that have been collected so far...'])

        varargout = prepOutput(nargout,evalResults,critGelRub,sequences,metropolisRejects,conf);

    end

end










% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % %                                             % % % % % %
% % % % % %       SODA LOCAL FUNCTIONS START HERE       % % % % % %
% % % % % %                                             % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %





% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
function conf = check_input_integrity(conf,nOut)


if nOut<2
    error(['Function ',39,mfilename,39,' should have at least 2 output arguments.',char(10),...
        '[evalResults,critGelRub] = soda()',char(10),...
        '[evalResults,critGelRub,conf] = soda()',char(10),...
        '[evalResults,critGelRub,sequences,conf] = soda()',char(10),...
        '[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda()',char(10)])
    
elseif all(nOut>[2:5])
    error(['Function ',39,mfilename,39,' should have at most 5 output arguments.',char(10),...
        '[evalResults,critGelRub] = soda()',char(10),...
        '[evalResults,critGelRub,conf] = soda()',char(10),...
        '[evalResults,critGelRub,sequences,conf] = soda()',char(10),...
        '[evalResults,critGelRub,sequences,metropolisRejects,conf] = soda()',char(10)])
end

if conf.nCompl<2
    error(['In order to determine the Gelman-Rubin convergence',10,...
        'criterion, at least 2 complexes should be used.'])
end

x = conf.nSamples/conf.nCompl;
if round(x)~=x
    error(['Unable to uniformly distribute number of samples (',...
        num2str(conf.nSamples),') over the given number ',10,...
        'of complexes (',num2str(conf.nCompl),').'])
elseif x<=0
    error(['Variable ',39,'conf.nSamples',39,' must be larger than zero.'])
end

x = conf.nOffspring/conf.nCompl;
if round(x)~=x
    error(['Unable to uniformly distribute number of offspring (',...
        num2str(conf.nOffspring),') over the given number ',10,...
        'of complexes (',num2str(conf.nCompl),').'])
elseif x<=0
    error(['Variable ',39,'conf.nOffspring',39,' must be larger than zero.'])
end
clear x

if conf.convUseLastFraction<=0
    error(['Value of parameter ',39,'conf.convUseLastFraction',39,' should be larger than 0.'])
end

if conf.convUseLastFraction>1
    error(['Value of parameter ',39,'conf.convUseLastFraction',39,' should be smaller than or equal to 1.'])
end

if conf.startFromUniform &&...
        mod((conf.nModelEvalsMax-conf.nSamples),conf.nOffspring)~=0

    suggestedValue = conf.nSamples+ceil((conf.nModelEvalsMax-...
        conf.nSamples)/conf.nOffspring)*conf.nOffspring;

    error(['Generating ',char(39),'conf.nOffspring',char(39),...
        ' (',num2str(conf.nOffspring),') descendants per ',...
        'generation will not ',char(10),'yield exactly ',char(39),...
        'conf.nModelEvalsMax',char(39),' (',...
        num2str(conf.nModelEvalsMax),') model evaluations ',...
        'for any',char(10),'integer number of generations, given ',...
        'that ',char(39),'conf.nSamples',char(39),' equals ',...
        num2str(conf.nSamples),'.',char(10),'Suggested value = ',num2str(suggestedValue),'.'])


end

if ~all(conf.parSpaceLoBound<conf.parSpaceHiBound)
    error(['Parameter domain boundaries incorrectly specified. Check parameters ',...
        char(39),'conf.parSpaceLoBound',char([39,10]),...
        'and ',char(39),'conf.parSpaceHiBound',char(39),'.'])
end


isSingleObjective = isfield(conf,'objCallStr');
isMultiObjective = isfield(conf,'objCallStrs');
if isSingleObjective && isMultiObjective
    error('You are using both ''.objCallStr'' and ''.objCallStrs'' fields.')
elseif isSingleObjective
    conf.isSingleObjective = true;
    conf.isMultiObjective = false;
    conf.nObjs = 1;
    conf.paretoMethod = 'none';
elseif isMultiObjective
    conf.isSingleObjective = false;
    conf.isMultiObjective = true;
    conf.nObjs = numel(conf.objCallStrs);
else
    error('You are not using ''.objCallStr'' or ''.objCallStrs'' fields.')
end

switch conf.modeStr
    case 'scemua'
        rmFields = {'covModelPert';...
                    'covObsPert';...
                    'initMethodKF';...
                    'initMethodNOKF';...
                    'initValuesKF';...
                    'initValuesNOKF';...
                    'obsState';...
                    'stateNamesKF';...
                    'stateSpaceLoBound';...
                    'stateSpaceHiBound'};
    case 'soda'
        rmFields = {};
    case 'reset'
        rmFields = {'errModelCallStr'};
    case 'bypass'
        rmFields = {'assimilate';...
                    'covModelPert';...
                    'covObsPert';...
                    'initMethodKF';...
                    'initMethodNOKF';...
                    'initValuesKF';...
                    'initValuesNOKF';...
                    'modelName';...
                    'namesNOKF';...
                    'obsState';...
                    'priorTimes';...
                    'stateNamesKF';...
                    'stateSpaceLoBound';...
                    'stateSpaceHiBound';...
                    'saveEnKFResults'};
    otherwise
end
for k=1:size(rmFields,1)
    if isfield(conf,rmFields{k,1})
        disp(['Removing field ',char(39),rmFields{k,1},char(39),' from conf.'])
        conf = rmfield(conf,rmFields{k,1});
    end
end
clear k
clear rmFields


if strncmp(conf.modeStr,'soda',4) && ~all(conf.stateSpaceLoBound<conf.stateSpaceHiBound)
    error(['State domain boundaries incorrectly specified. Check parameters ',...
        char(39),'conf.stateSpaceLoBound',char([39,10]),...
        'and ',char(39),'conf.stateSpaceHiBound',char(39),'.'])
end


if isfield(conf,'optMethod')
    error('The ''optMethod'' field in ''conf'' is deprecated.')
end

switch conf.modeStr
    case {'scemua','bypass'}
        shouldBeRowList = {'parNames','parSpaceLoBound','parSpaceHiBound'};
    case {'soda','reset'}
        shouldBeRowList = {'parNames','parSpaceLoBound','parSpaceHiBound','stateNamesKF',...
        'stateNamesNOKF','stateSpaceLoBound','stateSpaceHiBound'};
end
for k=1:numel(shouldBeRowList)
    if isfield(conf,shouldBeRowList{k})
        eval(['TMP = conf.',shouldBeRowList{k},';'])
        if size(TMP,1)>1
            error('SODA:shouldBeRowVariable',['Option ',char(39),'conf.',...
                shouldBeRowList{k},char(39),' should be a 1xN variable.'])
        end
    end
end
clear shouldBeRowList TMP k

if any(strcmp(conf.modeStr,{'soda','reset'}))
    if ~(isvector(conf.obsState) && isrow(conf.obsState))
        error('conf.obsState should be row vector')
    end
end
C ={'doPlot','realPartOnly','startFromUniform',...
    'verboseOutput'};
for k=1:numel(C)
    if isfield(conf,C{k})
        str = ['IO=~islogical(conf.',C{k},');'];
        eval(str)
        if IO
            error(['Field ',char(39),C{k},char(39), ' should be logical.'])
        end
    end
end
clear C


switch conf.modeStr
    case {'scemua','bypass'}
        if ~isfield(conf,'nMembers')
            disp(['Setting value of ',char(39),'conf.nMembers',char(39),' to 1.'])
            conf.nMembers = 1;
        end
        if conf.nMembers~=1
            disp(['Resetting value of ',char(39),'conf.nMembers',char(39),' from ',sprintf('%d',conf.nMembers),' to 1.'])
            conf.nMembers = 1;
        end
    case 'soda'
        
        if size(conf.covModelPert,1) ~= conf.nStatesKF
            error('size(covModelPert,1) is not equal to conf.nStatesKF')
        end
        if size(conf.covModelPert,2) ~= conf.nStatesKF
            error('size(covModelPert,2) is not equal to conf.nStatesKF')
        end
        if size(conf.covModelPert,3) == 1
            conf.covModelPert = repmat(conf.covModelPert,[1,1,conf.nDASteps]);
        end
        if size(conf.covModelPert,3) ~= conf.nDASteps
            error('size(conf.covModelPert,3) ~= conf.nDASteps')
        end

        if size(conf.covObsPert,1) ~= conf.nStatesKF
            error('size(covObsPert,1) is not equal to conf.nStatesKF')
        end
        if size(conf.covObsPert,2) ~= conf.nStatesKF
            error('size(covObsPert,2) is not equal to conf.nStatesKF')
        end
        if size(conf.covObsPert,3) == 1
            conf.covObsPert = repmat(conf.covObsPert,[1,1,conf.nDASteps]);
        end
        if size(conf.covObsPert,3) ~= conf.nDASteps
            error('size(conf.covObsPert,3) ~= conf.nDASteps')
        end
        
    case {'reset'}
        if ~isfield(conf,'nMembers')
            disp(['Setting value of ',char(39),'conf.nMembers',char(39),' to 1.'])
            conf.nMembers = 1;
        end
        if conf.nMembers~=1
            disp(['Resetting value of ',char(39),'conf.nMembers',char(39),' to 1.'])
            conf.nMembers = 1;
        end
        if conf.covObsPert~=0
            disp(['Resetting value of ',char(39),'conf.covObsPert',char(39),' to 0.'])
            conf.covObsPert = 0;
        end
        if size(conf.covObsPert,3) == 1
            conf.covObsPert = repmat(conf.covObsPert,[1,1,conf.nDASteps]);
        end
        if size(conf.covModelPert,3) == 1
            conf.covModelPert = repmat(conf.covModelPert,[1,1,conf.nDASteps]);
        end

end


if isfield(conf,'initValuesNOKF') && ~iscolumn(conf.initValuesNOKF)
    error('''conf.initValuesNOKF'' should be a column vector.')
end

if isfield(conf,'initValuesKF') && ~iscolumn(conf.initValuesKF)
    error('''conf.conf.initValuesKF'' should be a column vector.')
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
function disp_disclaimer

disp([10,...
    '% This is a pre-alpha release of the SODA simultaneous ',10,...
    '% parameter optimization and data assimilation software.',10])

if uimatlab
    disp(['% See <a href=',34,'matlab:web(fullfile(sodaroot,',...
           39,'html',39,',',39,'gpl.txt',39,'),',39,...
          '-helpbrowser',39,')',34,'>link</a> for license.',10,10])
end




function outCell = prepOutput(nOut,evalResults,critGelRub,sequences,metropolisRejects,conf)

evalResults = sortrows(evalResults,conf.evalCol);

if nOut==2
    outCell{1}=evalResults;
    outCell{2}=critGelRub;
elseif nOut==3
    outCell{1}=evalResults;
    outCell{2}=critGelRub;
    outCell{3}=orderfields(conf);
elseif nOut==4
    outCell{1}=evalResults;
    outCell{2}=critGelRub;
    outCell{3}=sequences;
    outCell{4}=orderfields(conf);
elseif nOut==5
    outCell{1}=evalResults;
    outCell{2}=critGelRub;
    outCell{3}=sequences;
    outCell{4}=metropolisRejects;
    outCell{5}=orderfields(conf);
else
    error(['Function ',39,mfilename,39,' should have at least 2 output arguments.'])
end



function checkIfFoldersExist()

if ~(exist('./data','dir')==7)
    warning('I don''t see a folder ''data''.')
end

if ~(exist('./model','dir')==7)
    error('I don''t see a folder ''model''.')
end

%if ~(exist('./piped','dir')==7)
    %error('I don''t see a folder ''piped''.')
%end

if ~(exist('./results','dir')==7)
    error('I don''t see a folder ''results''.')
end

%if ~(exist('./soda-piped-mo','dir')==7)
    %error('I don''t see a folder ''soda-piped-mo''.')
%end

%if ~(exist('./streams','dir')==7)
    %error('I don''t see a folder ''streams''.')
%end



