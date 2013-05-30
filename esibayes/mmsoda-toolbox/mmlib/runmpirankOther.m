
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


confFile = './results/conf-out.mat';
constantsFile = './data/constants.mat';

if isdeployed
    conf = bcastvar(0,0);
else
    % this scripts is called by runmpirankOtherFun, conf variable exists
end

if exist(constantsFile,'file')==2
    constants = load(constantsFile);
else
    if strcmp(conf.modeStr,'bypass')
        % do nothing
    elseif conf.executeInParallel
        fprintf('%03d - I don''t see the constants file...attempting to proceed without it.',mpirank)
    else
        disp('I don''t see the constants file...attempting to proceed without it.')
    end
    constants = struct([]);
end



sumrun=0;
runcounter=0;


if conf.executeInParallel
    while true

        msg = receivevar(0);
        timer = tic;
        if ischar(msg)
            switch msg
                case 'die'
                    if verbosity>=1
                        str=sprintf('%03d - Server wants me to die.',mpirank);
                        disp(str)
                    end
                    break % out of the enclosing while
                otherwise
                    disp(msg)
            end % switch
        elseif isstruct(msg)

            bundle = msg; % this is a memory-efficient way of
            clear msg     % renaming a variable

            bundle = mmsodaProcessBundle(conf,constants,bundle);

            sendvar(0,bundle);
        end % if

    end % while

else % if conf.executeInParallel

    bundle = msg; % this is a memory-efficient way of
    clear msg     % renaming a variable

    bundle = mmsodaProcessBundle(conf,constants,bundle);


end % if conf.executeInParallel






