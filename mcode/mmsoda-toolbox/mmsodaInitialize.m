function varargout = mmsodaInitialize(mmsodaOptions)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaInitialize.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

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


conf.verboseOutput = ~any(strcmp('--quiet',mmsodaOptions)|strcmp('-q',mmsodaOptions));

switch mmsodaOptions{1}
    case {'--docinstall','-d'}
        %             try
        % try
        if conf.verboseOutput
            mmsoda('--addtools')
        else
            mmsoda('--addtools','--quiet')
        end
        
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

                fid=fopen(fullfile(mmsodaroot,'html','styles','mmsoda-styles.css.template'),'r');
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


                fid=fopen(fullfile(mmsodaroot,'html','styles','mmsoda-styles.css'),'wt');
                fprintf(fid,textStylesCSS,...
                    Colors_M_CommentsStr,...
                    Colors_M_StringsStr,...
                    Colors_M_KeywordsStr,...
                    Colors_M_SystemCommandsStr);
                fclose(fid);


                if conf.verboseOutput
                    disp(['MMSODA: ',char(39),'mmsoda-styles.css',char(39),' has been updated successfully.'])
                end

                %if conf.verboseOutput && uimatlab
                    %disp(['Click on the MATLAB ',...
                        %'Start button->Desktop Tools->View Start Button Configuration Files...',...
                        %char(10),'...and click Refresh Start Button.'])
                %end
%                 
%                 
%                 lines = '';
%                 fidr=fopen(fullfile(mmsodaroot,'info.xml.template'),'r');
%                 tline = fgets(fidr);
%                 while ischar(tline)
%                     lines = [lines,tline];
%                     tline = fgets(fidr);                    
%                 end
%                 fclose(fidr);
%                 
%                 fidw = fopen(fullfile(mmsodaroot,'info.xml'),'wt');
%                 fprintf(fidw,lines,mmsodaroot);
%                 status = fclose(fidw);
%                 

                

            else
                if uioctave
                    disp('You seem to be on octave. CSS files not written. Never mind.')
                end
            end
        catch
            if conf.verboseOutput
                warning('MMSODA:writing_of_styles_file',...
                    ['An error occurred during writing ',...
                    'of ',char(39),...
                    'mmsoda-styles.css',char(39),' file'])
            end
        end
        %     end

    case {'--addtools','-a'}
        try

            p = mfilename('fullpath');
            u = findstr(p,mfilename);
            addpath(fullfile(p(1:u(end)-1),'tools'))
            addpath(fullfile(mmsodaroot,'visualization'))
            addpath(fullfile(mmsodaroot,'enkf'))
            addpath(fullfile(mmsodaroot,'mo'))
            if ~isdeployed
                addpath('model')
                if strcmp(lastwarn,'Name is nonexistent or not a directory: model.')
                    disp('Are you currently in the right directory?')
                    % reset warning state:
                    lastwarn('')
                end
                % addpath('data')
                % addpath('results')
                addpath(fullfile(mmsodaroot,'mmlib'))
                addpath(fullfile(mmsodaroot,'comms'))
            end
            if conf.verboseOutput
                disp('MMSODA: tools should now be available.')
            end

        catch
            if conf.verboseOutput
                warning('MMSODA:add_mmsoda_tools',['An error occurred ',...
                    'while trying to add ',char(10),...
                    'the MMSODA tools to the path.'])
            end
        end
    case {'--help','-h'}
        if conf.verboseOutput
            disp(['% mmsoda -docinstall ',char(10),...
                  '%       adds some folders to the path, which contain helpful',char(10),...
                  '%       functions, and installs the documentation by writing ',char(10),...
                  '%       the info.xml file.',char(10)...
                  '%',char(10),...
                  '% mmsoda --addtools ',char(10)...
                  '%       adds some folders to the path, which contain helpful',char(10),...
                  '%       functions.',char(10),...
                  '%',char(10),...
                  '% mmsoda -help ',char(10),...
                  '%       shows this help.',char(10),...
                  '%',char(10),...
                  '% mmsoda --rmpath',char(10),...
                  '%       removes the MMSODA directories from the path',char(10),...
                  '%',char(10),...
                  '% mmsoda --showoptions',char(10),...
                  '%       lists the valid options for the MMSODA function.',char(10)...
                  '%',char(10),...
                  '% mmsoda --root',char(10),...
                  '%       returns the root of the MMSODA toolbox.',char(10),...
                  '%',char(10),...
                   ])
        end

    case {'--rmpath','p'}
        
        rmpath(fullfile(mmsodaroot,'visualization'))
        rmpath(fullfile(mmsodaroot,'enkf'))
        rmpath(fullfile(mmsodaroot,'mo'))
        if ~isdeployed
            rmpath('model')
            % rmpath('data')
            % rmpath('results')
            rmpath(fullfile(mmsodaroot,'mmlib'))
            rmpath(fullfile(mmsodaroot,'comms'))
        end
        tmp = mmsodaroot;
        rmpath(fullfile(tmp,'tools'))
        rmpath(tmp)        
        clear tmp
        
        disp('MMSODA toolbox has successfully been removed from the path.')

    case {'--showoptions','-s'}
        mmsodaVerifyFieldNames(conf,'show')

    case {'--root','-r'}
        a=mfilename('fullpath');
        Ix=findstr(a,[filesep,'mmsoda']);
        s=a(1:Ix(end));
        varargout{1} = s;
        return

    case {'--builddb','-b'}
        
        disp('Building docsearch database...')
        builddocsearchdb(fullfile(mmsodaroot,'html'))
        return

    otherwise
        if conf.verboseOutput
            warning('MMSODA:DocInstall',['For installing the documen',...
                'tation, type >>mmsoda --docinstall'])
        end
end
