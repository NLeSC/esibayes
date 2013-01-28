function varargout = sodaInitialize(sodaOptions)
%
% <a href="matlab:web(fullfile(sodaroot,'html','sodaInitialize.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

conf.verboseOutput = ~any(strcmp('--quiet',sodaOptions)|strcmp('-q',sodaOptions));

switch sodaOptions{1}
    case {'--docinstall','-d'}
        %             try
        % try
        if conf.verboseOutput
            soda('--addtools')
        else
            soda('--addtools','--quiet')
        end
        
        % build searchable help database
        soda('--builddb')
        
        try
            if uimatlab

                Colors_M_CommentsStr = '228B22';
                Colors_M_StringsStr = 'A020F0';
                Colors_M_KeywordsStr = '0000FF';
                Colors_M_SystemCommandsStr = 'B28C00';

                prefFile = fullfile(prefdir,'matlab.prf');
                if exist(prefFile,'file')==2

                    fid=fopen(prefFile,'r');
                    C = textscan(fid, '%s','delimiter','\r');
                    fclose(fid);

                    for k=1:numel(C{1})
                        try
                            MatlabVarName = strread(C{1}{k},'%[^=]',1);
                            switch MatlabVarName{1}
                                case 'Colors_M_Comments'
                                    indColor = strread(C{1}{k},'%*[^=]%*[=]%s',1);
                                    [r,g,b]=indexed2hexcolor(indColor{1});
                                    Colors_M_CommentsStr =...
                                        [dec2hex(r,2),dec2hex(g,2),dec2hex(b,2)];
                                case 'Colors_M_Strings'
                                    indColor = strread(C{1}{k},'%*[^=]%*[=]%s',1);
                                    [r,g,b]=indexed2hexcolor(indColor{1});
                                    Colors_M_StringsStr =...
                                        [dec2hex(r,2),dec2hex(g,2),dec2hex(b,2)];
                                case 'Colors_M_Keywords'
                                    indColor = strread(C{1}{k},'%*[^=]%*[=]%s',1);
                                    [r,g,b]=indexed2hexcolor(indColor{1});
                                    Colors_M_KeywordsStr =...
                                        [dec2hex(r,2),dec2hex(g,2),dec2hex(b,2)];
                                case 'Colors_M_SystemCommands'
                                    indColor = strread(C{1}{k},'%*[^=]%*[=]%s',1);
                                    [r,g,b]=indexed2hexcolor(indColor{1});
                                    Colors_M_SystemCommandsStr =...
                                        [dec2hex(r,2),dec2hex(g,2),dec2hex(b,2)];
                            end
                        catch

                        end
                    end
                end

                fid=fopen(fullfile(sodaroot,'html','styles','soda-styles.css.template'),'r');
                textStylesCSS='';
                while true
                    tline = fgets(fid);
                    if ischar(tline)
                        textStylesCSS = [textStylesCSS,tline];
                    else
                        break
                    end
                end
                fclose(fid);


                fid=fopen(fullfile(sodaroot,'html','styles','soda-styles.css'),'wt');
                fprintf(fid,textStylesCSS,...
                    Colors_M_CommentsStr,...
                    Colors_M_StringsStr,...
                    Colors_M_KeywordsStr,...
                    Colors_M_SystemCommandsStr);
                fclose(fid);


                if conf.verboseOutput
                    disp(['SODA: ',char(39),'soda-styles.css',char(39),' has been updated successfully.'])
                end

                %if conf.verboseOutput && uimatlab
                    %disp(['Click on the MATLAB ',...
                        %'Start button->Desktop Tools->View Start Button Configuration Files...',...
                        %char(10),'...and click Refresh Start Button.'])
                %end

            else
                if uioctave
                    disp('You seem to be on octave. CSS files not written. Never mind.')
                end
            end
        catch
            if conf.verboseOutput
                warning('SODA:writing_of_styles_file',...
                    ['An error occurred during writing ',...
                    'of soda ',char(39),...
                    'soda-styles.css',char(39),' file'])
            end
        end
        %     end

    case {'--addtools','-a'}
        try

            p = mfilename('fullpath');
            u = findstr(p,mfilename);
            addpath(fullfile(p(1:u(end)-1),'tools'))
            addpath(fullfile(sodaroot,'visualization'))
            addpath(fullfile(sodaroot,'enkf'))
            addpath(fullfile(sodaroot,'mo'))
            if ~isdeployed
                addpath('model')
                % addpath('data')
                % addpath('results')
                addpath(fullfile(sodaroot,'mmlib'))
                addpath(fullfile(sodaroot,'comms'))
            end
            if conf.verboseOutput
                disp('SODA: tools should now be available.')
            end

        catch
            if conf.verboseOutput
                warning('SODA:add_soda_tools',['An error occurred ',...
                    'while trying to add ',char(10),...
                    'the SODA tools to the path.'])
            end
        end
    case {'--help','-h'}
        if conf.verboseOutput
            disp(['% soda -docinstall ',char(10),...
                  '%       adds some folders to the path, which contain helpful',char(10),...
                  '%       functions, and installs the documentation by writing ',char(10),...
                  '%       the info.xml file.',char(10)...
                  '%',char(10),...
                  '% soda --addtools ',char(10)...
                  '%       adds some folders to the path, which contain helpful',char(10),...
                  '%       functions.',char(10),...
                  '%',char(10),...
                  '% soda -help ',char(10),...
                  '%       shows this help.',char(10),...
                  '%',char(10),...
                  '% soda --rmpath',char(10),...
                  '%       removes the SODA directories from the path',char(10),...
                  '%',char(10),...
                  '% soda --showoptions',char(10),...
                  '%       lists the valid options for the SODA function.',char(10)...
                  '%',char(10),...
                  '% soda --root',char(10),...
                  '%       returns the root of the SODA toolbox.',char(10),...
                  '%',char(10),...
                   ])
        end

    case {'--rmpath','p'}
        
        rmpath(fullfile(sodaroot,'visualization'))
        rmpath(fullfile(sodaroot,'enkf'))
        rmpath(fullfile(sodaroot,'mo'))
        if ~isdeployed
            rmpath('model')
            % rmpath('data')
            % rmpath('results')
            rmpath(fullfile(sodaroot,'mmlib'))
            rmpath(fullfile(sodaroot,'comms'))
        end
        tmp = sodaroot;
        rmpath(fullfile(tmp,'tools'))
        rmpath(tmp)        
        clear tmp
        
        disp('SODA toolbox has successfully been removed from the path.')

    case {'--showoptions','-s'}
        sodaVerifyFieldNames(conf,'show')

    case {'--root','-r'}
        a=mfilename('fullpath');
        Ix=findstr(a,[filesep,'soda']);
        s=a(1:Ix(end));
        varargout{1} = s;
        return

    case {'--builddb','-b'}
        
        disp('Building docsearch database...')
        builddocsearchdb(fullfile(sodaroot,'html'))
        return

    otherwise
        if conf.verboseOutput
            warning('SODA:DocInstall',['For installing the documen',...
                'tation, type >>soda --docinstall'])
        end
end
