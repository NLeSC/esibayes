function varargout = mmsoda(varargin)
% % Serial/parallel, single-objective/multi-objective SCEM-UA and SODA using MPI
% %
% % <a href="matlab:web(fullfile(mmsodaroot,'html','mmsoda.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
% %
% % Before you can access MMSODA's functionality, you need to run the
% % following command once (per MATLAB session):
% % >> mmsoda --docinstall
% % <a href="matlab:mmsoda --docinstall">Install documentation now</a>
% %
% %
% % Also, make sure to check out the <a href="matlab:mmsodaOpenPdf(fullfile(mmsodaroot,'pdf','2013-mmsoda-manual.pdf'))">manual</a> (link requires 'pdfviewer=' to be set
% % in <a href="matlab:edit(fullfile(mmsodaroot,'helper-apps.txt'))">helper-apps.txt</a>; see <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaOpenPdf.html'),'-helpbrowser')">doc mmsodaOpenPdf</a>).
% %
% %
% % This software is based on sequential and parallel implementations of
% % single-objective and multi-objective versions of SCEM-UA and SODA
% % algorithms by J.A. Vrugt
% %
% %
% % Author         : Jurriaan H. Spaaks
% % Date           : March 2013
% % Matlab release : 2008a on Windows 7 64-bit
% %                  2012a on Lubuntu Linux 12.04 64-bit


% %

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END




if nargin == 0 && nargout == 0
    mmsoda --help
    return
end

if ~isempty(varargin) && ischar(varargin{1})

    mmsodaInitialize(varargin)

else

    % display disclaimer:
    disp_disclaimer

    try
        conf = load('./results/conf.mat');
    catch
        error('I can''t find the *.mat file that holds the SODA configuration.')
    end

    if ~isdeployed
        try
            % add constants variables to the base workspace such that the
            % runmpirankOther can retrieve it from there
            evalin('base','constants = load(''./data/constants.mat'');')
        catch
            if ~strcmp(conf.modeStr,'bypass')
                disp('I don''t see the constants file...attempting to proceed without it.')
            end
        end
    end


    % define whether the run is parallel or sequential
    conf.executeInParallel = isdeployed;
    if conf.executeInParallel
        %disp('DEBUG: before verbosity')
        verbosity = evalin('caller','verbosity');
        %disp('DEBUG: after verbosity')
    end

    % verify the integrity of conf's fieldnames:
    mmsodaVerifyFieldNames(conf,'check')

    conf.nOptPars = numel(conf.parNames);

    % load default settings from file:
    if isfield(conf,'useIniFile')
        fileStr = fullfile(mmsodaroot,conf.useIniFile);
        conf = mmsodaLoadSettings(conf,fileStr);
    else
        fileStr = fullfile(mmsodaroot,'mmsoda-default-settings.ini');
        conf = mmsodaLoadSettings(conf,fileStr);
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


    % check if any inconsistencies can be identified from conf's fields:
    conf = check_input_integrity(conf,nargout);
    checkIfFoldersExist();

    if ~conf.parameterSamplesAreGiven
        % number of samples per complex:
        conf.nSamplesPerCompl = conf.nSamples/conf.nCompl;

        %number of offspring per complex:
        conf.nOffspringPerCompl = conf.nOffspring/conf.nCompl;
    end

    % Indicate the meaning of each column in 'evalResults':
    if conf.isSingleObjective
        conf.evalCol = 1;                                     % model evaluation counter
        conf.parCols = conf.evalCol+(1:conf.nOptPars);        % model parameters
        conf.llCols = conf.parCols(end)+1;                    % log likelihood
        conf.paretoCol = NaN;                                 % pareto score not defined for single-objective
        conf.objCol = conf.llCols(1);                         % SCEM-UA's decision-mkaing is based on this col
    elseif conf.isMultiObjective
        conf.evalCol = 1;                                     % model evaluation counter
        conf.parCols = conf.evalCol+(1:conf.nOptPars);        % model parameters
        conf.llCols = conf.parCols(end)+(1:conf.nObjs);       % log likelihoods
        conf.paretoCol = conf.llCols(end)+1;                  % pareto score
        conf.objCol = conf.paretoCol;                         % SCEM-UA's decision-mkaing is based on this col
    else
    end

    if conf.executeInParallel
        % specify the number of workers
        %disp('DEBUG: before mpisize')
        if ~(exist('mpisize','var')==1)
            whoami()
        end
        %disp('DEBUG: after verbosity')
        conf.nWorkers = mpisize-1;
    else
        conf.nWorkers = 1;
    end

    conf.optStartTime = now;

    if isfield(conf,'walltime')
        conf.optEndTime = conf.optStartTime + conf.walltime;
    end

    %initialize the gelman-rubin statistic record:
    critGelRub = [];

    authorizedFieldNames = mmsodaVerifyFieldNames([],'return');
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


    conf = orderfields(conf);
    saveList = sort(saveList);

    if ~conf.parameterSamplesAreGiven
        % check if there are any results in ./results that are inconsistent with
        % the current configuration:
        mmsodaCheckForOldResults(conf);
    end

    if conf.executeInParallel
        bcastvar(0,conf);
    end

    clear authorizedFieldNames
    clear iVar
    clear nVars
    clear varName
    clear varList

    if conf.isMultiObjective
        soMoStr = '-mo';
    elseif conf.isSingleObjective
        soMoStr = '-so';
    else
    end
    disp([char(10),upper([conf.modeStr,soMoStr]),' run started on: ',datestr(conf.optStartTime,...
        'mmmm dd, yyyy'),' ',datestr(conf.optStartTime,'HH:MM:SS')])
    clear s

    
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % %                                             % % % % % %
    % % % % % %      SODA  INITIALIZATION FINISHED          % % % % % %
    % % % % % %                                             % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

    if conf.parameterSamplesAreGiven

        load('./data/parameter-samples.mat')
        
        conf.nSamples = size(samples,1);
        conf.nModelEvalsMax = conf.nSamples;
        
        save('./results/conf-out.mat','-struct','conf',saveList{:})

        evalResults = repmat(NaN,[conf.nSamples,conf.objCol]);
        evalResults(:,conf.evalCol) = (1:conf.nSamples)';
        evalResults(:,conf.parCols) = samples;
        evalResults(:,conf.llCols) = mmsodaCalcObjScore(conf,evalResults);
        if conf.isMultiObjective
            evalResults(:,conf.paretoCol) = -mmsodaCalcPareto(evalResults(:,conf.llCols),conf.paretoMethod);
        end
        varargout{1} = evalResults;
        varargout{5} = conf;
        
        return

    end

    save('./results/conf-out.mat','-struct','conf',saveList{:})

    
    if conf.startFromUniform

        switch conf.sampleDrawMode
            case 'stratified random'
                % Startified uniform random sampling of points
                % in parameter space:
                randomDraw = mmsodaStratRandDraw(conf);
            case 'stratified'
                % Startified sampling of points in parameter space:
                randomDraw = mmsodaStratDraw(conf);
        end

        
        evalResults = repmat(NaN,[conf.nSamples,conf.objCol]);
        evalResults(:,conf.evalCol) = (1:conf.nSamples)';
        % randomize the order of randowDraw for better load balancing:
        evalResults(:,conf.parCols) = randomDraw(randperm(conf.nSamples),:);
        evalResults(:,conf.llCols) = mmsodaCalcObjScore(conf,evalResults);
        if conf.isMultiObjective
            evalResults(:,conf.paretoCol) = -mmsodaCalcPareto(evalResults(:,conf.llCols),conf.paretoMethod);
        end

        nModelEvals = size(evalResults,1);

        % partition 'evalResults' into complexes and initialize the sequences:
        complexes = mmsodaPartComplexes(conf,evalResults);
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
        load(['./results/',thisconf.modeStr,'-',s,'-tempstate.mat'],...
            'conf','critGelRub','evalResults','metropolisRejects',...
            'sequences','complexes')

        thatconf = conf;

        ignoreFields = {'startFromUniform','nModelEvalsMax','optStartTime',...
                        'saveInterval','verboseOutput','doPlot','executeInParallel',...
                        'saveEnKFResults','drawInterval','optEndTime',...
                        'visualizationCall','nWorkers','avgWalltimePerParSet','walltime'};
        if ~isempty(mmsodaDiffStruct(thisconf,thatconf,ignoreFields))
            error('Configuration is different from last time. Aborting.')
        else
            conf = thisconf;
            clear thisconf
            clear thatconf
            clear ignoreFields
            clear s
        end

        nModelEvals = evalResults(end,conf.evalCol);
        if conf.verboseOutput
            disp([upper(conf.modeStr),' run continues at ',num2str(nModelEvals+1), ' model evaluations.'])
        end

    end
    conf = orderfields(conf);

    iGeneration  = (size(evalResults,1)-conf.nSamples)/conf.nOffspring;


    if conf.saveInterval>0
        save(['./results/',conf.modeStr,soMoStr,'-tempstate.mat'],'-mat',...
                            'evalResults','critGelRub','sequences','metropolisRejects','conf','complexes')
    end
    if conf.doPlot
        eval(conf.visualizationCall)
    end


    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % %                                                         % % % % % %
    % % % % % %            SODA  START OF MAIN LOOP                     % % % % % %
    % % % % % %                                                         % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
    % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


    try
        while mmsodaContinue(conf,nModelEvals)

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
                    propChildren(iOffspring,:,iCompl) = mmsodaGenerateOffspring(conf,curCompl,curSeq,iGeneration);
                    propChildren(iOffspring,conf.evalCol,iCompl) = nModelEvals;

                end % iOffspring = 1:conf.nOffspringPerCompl

            end % iCompl=1:conf.nCompl

            % calculate objective for unevaluated rows of evalResults:
            propChildren(:,conf.llCols,:) = mmsodaCalcObjScore(conf,propChildren);

            if conf.isMultiObjective
                % recalculate the global pareto scores based on the objectives
                % scores of the last row in each sequence, plus all scores in
                % complexes, plus all scores in propChildren:
                lastRowsOfSequences = sequences(end,:,:);
                [lastRowsOfSequences,complexes,propChildren] = mmsodaRecalcPareto(conf,lastRowsOfSequences,complexes,propChildren);
                sequences = cat(1,sequences(1:end-1,:,:),lastRowsOfSequences);
            end

            sequences = mmsodaPrepSeqArray(conf,sequences);
            metropolisRejects = mmsodaPrepRejArray(conf,metropolisRejects);

            for iCompl=1:conf.nCompl

                % select the current complex:
                curCompl = complexes(:,:,iCompl);

                % select the current sequence:
                curSeq = sequences(:,:,iCompl);

                for iOffspring = 1:conf.nOffspringPerCompl

                    % evolve the current complex by accepting the proposed child...
                    % or by re-accepting the last child from the current sequence:
                    propChild = propChildren(iOffspring,:,iCompl);

                    [curCompl,acceptedChild] = mmsodaEvolveComplex(conf,curCompl,curSeq,propChild);

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
            complexes = mmsodaPartComplexes(conf,evalResults);

            iGeneration = (nModelEvals-conf.nSamples)/conf.nOffspring;

            %determine the Gelman-Rubin scale reduction (convergence) statistic:
            critGelRub(iGeneration,:) = [nModelEvals,mmsodaGelmanRubin(conf,sequences)];

            % determine whether all parameters meet the Gelman-Rubin scale
            % reduction criterion
            conf.converged = mmsodaAbortOptim(critGelRub,conf);

            if conf.doPlot &&...
                (mod(iGeneration,conf.drawInterval)==0)
                if isunix && isempty(getenv('DISPLAY'))
                    warning('DISPLAY variable not set-- can''t plot anything.')
                else
                    eval(conf.visualizationCall)
                end
            end


            if mod(iGeneration,conf.saveInterval)==0

                save(['./results/',conf.modeStr,soMoStr,'-tempstate.mat'],'-mat',...
                            'evalResults','critGelRub','sequences','metropolisRejects','conf','complexes')

            end %  mod(iGeneration,...

            if conf.executeInParallel
                if conf.archiveResults
                    
                    envStr = getenv('PBS_JOBID');
                    if ~isempty(envStr)
                        tmp = textscan(envStr,'%[^.]');
                        jobidStr = tmp{1}{1};
                        clear tmp
                        copyfile('results',['results',jobidStr]);
                    end
                    clear envStr
                end
            end

        end % mmsodaContinue(conf,nModelEvals)

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

        conf = orderfields(conf);

        disp([upper([conf.modeStr,soMoStr]),' run completed on: ',datestr(conf.optEndTime,...
            'mmmm dd, yyyy'),' ',datestr(conf.optEndTime,'HH:MM:SS')])

        varargout = prepOutput(nargout,evalResults,critGelRub,sequences,metropolisRejects,conf);


        % save the results
        save(['./results/',conf.modeStr,soMoStr,'-results.mat'],...
             'evalResults','critGelRub','sequences','metropolisRejects','conf','complexes')

        save(['./results/',conf.modeStr,soMoStr,'-tempstate.mat'],'-mat',...
             'evalResults','critGelRub','sequences','metropolisRejects','conf','complexes')


        if conf.executeInParallel
            for iWorker = 1:conf.nWorkers
                sendvar(iWorker,'die');
            end
            pause(10)
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




    catch err

        disp([err.message,char(10),...
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
        '[evalResults,critGelRub] = mmsoda()',char(10),...
        '[evalResults,critGelRub,conf] = mmsoda()',char(10),...
        '[evalResults,critGelRub,sequences,conf] = mmsoda()',char(10),...
        '[evalResults,critGelRub,sequences,metropolisRejects,conf] = mmsoda()',char(10)])

elseif all(nOut>[2:5])
    error(['Function ',39,mfilename,39,' should have at most 5 output arguments.',char(10),...
        '[evalResults,critGelRub] = mmsoda()',char(10),...
        '[evalResults,critGelRub,conf] = mmsoda()',char(10),...
        '[evalResults,critGelRub,sequences,conf] = mmsoda()',char(10),...
        '[evalResults,critGelRub,sequences,metropolisRejects,conf] = mmsoda()',char(10)])
end

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
        conf.saveEnKFResults = false;
    end
elseif strcmp(conf.modeStr,'scemua')
    conf.nStatesKF = 0;
    conf.nNOKF = 0;
    conf.nDASteps = 0; % so that you can use the same code as for soda and reset modes
    conf.nPrior = numel(conf.priorTimes);
    if ~isfield(conf,'assimilate')
        conf.assimilate = repmat(false,[1,conf.nPrior]);
    end
elseif strcmp(conf.modeStr,'bypass') || strcmp(conf.modeStr,'bypass-noopt')
    conf.nStatesKF = 0;
    conf.nNOKF = 0;
    conf.nDASteps = 0;
    conf.nPrior = 0;
else
    % do nothing
end

if strcmp(conf.modeStr(end-3:end),'oopt')
    conf.parameterSamplesAreGiven = true;
else
    conf.parameterSamplesAreGiven = false;
end

if strcmp(conf.modeStr,'scemua') && ~isfield(conf,'nOutputs')
    error('When ''modeStr'' is ''scemua'', there needs to be a configuration variable ''nOutputs''.')
end

if ~conf.parameterSamplesAreGiven && conf.nCompl<2
    error(['In order to determine the Gelman-Rubin convergence',10,...
        'criterion, at least 2 complexes should be used.'])
end

if ~conf.parameterSamplesAreGiven
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

    if mod((conf.nModelEvalsMax-conf.nSamples),conf.nOffspring)~=0

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
                    'namesNOKF';...
                    'obsState';...
                    'stateNamesKF';...
                    'stateSpaceLoBound';...
                    'stateSpaceHiBound'};
    case 'soda'
        rmFields = {};
    case 'reset'
        rmFields = {'errModelCallStr'};
    case {'bypass','bypass-noopt'} 
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
                    'stateSpaceHiBound';};
         if conf.parameterSamplesAreGiven
             rmFields = [rmFields;...
                     'nCompl';...
                     'nOffspringFraction';...
                     'nOffspring';...
                     'jumpRate';...
                     'critGelRubConvd';...
                     'convUseLastFraction';... 
                     'nGelRub';...
                     'modeGelRub';...
                     'convMaxDiff';...
                     'thresholdL';...
                     'startFromUniform';...
                     'optEndTime';...
                     'converged';...
                     'randSeed';...
                     'visualizationCall';...
                     'verboseOutput';...
                     'realPartOnly';...
                     'saveInterval';...
                     'sampleDrawMode';...
                     'paretoMethod';...
                     'parNamesTex';...
                     'nStatesKF';...
                     'nNOKF';...
                       ];
         end
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

if conf.parameterSamplesAreGiven && any(strcmp(conf.modeStr,{'bypass','reset','soda'}))
   if isfield(conf,'nOutputs')
       error(['Configuration variable ''nOutputs'' is not allowed in ',char(39),conf.modeStr,char(39),' mode.'])
   end
end


mustBeCellOfStr = {'namesNOKF','objCallStrs','objTexNames','parNames','parNamesTex','stateNamesKF'};
for k=1:numel(mustBeCellOfStr)
    if isfield(conf,mustBeCellOfStr{k}) && ~iscellstr(conf.(mustBeCellOfStr{k}))
        error(['Configuration variable ',char(39),mustBeCellOfStr{k},char(39),' should be a cell array of strings.'])
    end
end
clear mustBeCellOfStr;
clear k;

if conf.parameterSamplesAreGiven && strncmp(conf.modeStr,'soda',4) && ~all(conf.stateSpaceLoBound<conf.stateSpaceHiBound)
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
    case {'bypass-noopt'}
        shouldBeRowList = {'parNames'};
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

if conf.parameterSamplesAreGiven && any(strcmp(conf.modeStr,{'soda','reset'}))
    if ~isequal(size(conf.obsState),[conf.nStatesKF,conf.nDASteps])
        error('conf.obsState should be of size [conf.nStatesKF,conf.nDASteps].')
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
    case {'scemua','bypass','bypass-noopt'}
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

        if ~isfield(conf,'covObsPert')
            disp(['Setting value of ',char(39),'conf.covObsPert',char(39),' to 0.'])
            conf.covObsPert = zeros(conf.nStatesKF,conf.nStatesKF);
        end
        if isfield(conf,'covObsPert') && ~isequal(conf.covObsPert,0)
            disp(['Resetting value of ',char(39),'conf.covObsPert',char(39),' to 0.'])
            conf.covObsPert = zeros(conf.nStatesKF,conf.nStatesKF);
        end
        if size(conf.covObsPert,3) == 1
            conf.covObsPert = repmat(conf.covObsPert,[1,1,conf.nDASteps]);
        end

        if ~isfield(conf,'covModelPert')
            disp(['Setting value of ',char(39),'conf.covModelPert',char(39),' to 0.'])
            conf.covModelPert = zeros(conf.nStatesKF,conf.nStatesKF);
        end
        if isfield(conf,'covModelPert') && ~isequal(conf.covModelPert,0)
            disp(['Resetting value of ',char(39),'conf.covModelPert',char(39),' to 0.'])
            conf.covModelPert = zeros(conf.nStatesKF,conf.nStatesKF);
        end
        if size(conf.covModelPert,3) == 1
            conf.covModelPert = repmat(conf.covModelPert,[1,1,conf.nDASteps]);
        end
end


if isfield(conf,'initValuesNOKF') && ~isempty(conf.initValuesNOKF) && ~mmsodaIsColumn(conf.initValuesNOKF)
    error('''conf.initValuesNOKF'' should be a column vector.')
end

if isfield(conf,'initValuesKF') && ~isempty(conf.initValuesKF) && ~mmsodaIsColumn(conf.initValuesKF)
    error('''conf.initValuesKF'' should be a column vector.')
end


if any(strcmp(conf.modeStr,{'reset','soda'}))

    if xor(isfield(conf,'initMethodNOKF'),isfield(conf,'initValuesNOKF'))
        error('You have to have both ''initMethodNOKF'' and ''initValuesNOKF'' for this to work.')
    else
        if ~isfield(conf,'initMethodNOKF') && ~isfield(conf,'initValuesNOKF')
            disp('Setting ''initMethodNOKF'' to ''reference''.')
            conf.initMethodNOKF = 'reference';
            disp('Setting ''initValuesNOKF'' to [].')
            conf.initValuesNOKF = [];
        end
    end
end


if isdeployed && isunix && isempty(getenv('DISPLAY')) && conf.doPlot
    warning('DISPLAY variable not set-- can''t plot anything.')
    disp('Resetting ''conf.doPlot'' to ''false''.')
    conf.doPlot = false;
end



% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
function disp_disclaimer

disp([10,...
    '% This is a pre-alpha release of the MMSODA simultaneous ',10,...
    '% parameter optimization and data assimilation software.',10])

if uimatlab
    disp(['% See <a href=',34,'matlab:web(fullfile(mmsodaroot,',...
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

if ~(exist('./results','dir')==7)
    error('I don''t see a folder ''results''.')
end




