function mmsodaParetoPrinciple()


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



% % generate 10 random objective scores on two objectives:
load(fullfile(mmsodaroot,'data','objscores.mat'),'objScores')

% calculate pareto ranking according to Goldberg (1989)
paretoScoreG = mmsodaCalcPareto(objScores,'g');

% calculate pareto ranking according to Zitzler and Thiele (1999)
paretoScoreZ = mmsodaCalcPareto(objScores,'z');

% calculate pareto ranking according to Vrugt et al. (2003)
paretoScoreV = mmsodaCalcPareto(objScores,'v');


% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                     % %
% %                    AND THE REST IS VISUALIZATION                    % %
% %                                                                     % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %

mmsodaSubplotScreen(1,1,1)
if uioctave
    fs=14;
elseif uimatlab
    fs=10;
else
end
subplot(2,2,1)
plot(objScores(:,1),objScores(:,2),'.')
text(objScores(:,1),objScores(:,2),[repmat(' ',...
                             size(paretoScoreG)),num2str(paretoScoreG)],...
                             'fontsize',fs)
set(gca,'xlim',[0,max(objScores(:,1))],'ylim',[0,max(objScores(:,2))])
xlabel('first objective')
ylabel('second objective')
title('Goldberg (1989) ranking')
set(gca,'xlim',[0,10],'ylim',[0,10])

subplot(2,2,2)
plot(objScores(:,1),objScores(:,2),'.')
text(objScores(:,1),objScores(:,2),[repmat(' ',...
                             size(paretoScoreZ)),num2str(paretoScoreZ)],...
                             'fontsize',fs)
set(gca,'xlim',[0,max(objScores(:,1))],'ylim',[0,max(objScores(:,2))])
xlabel('first objective')
ylabel('second objective')
title('Zitzler & Thiele (1999) ranking')
set(gca,'xlim',[0,10],'ylim',[0,10])

subplot(2,2,3)
plot(objScores(:,1),objScores(:,2),'.')
text(objScores(:,1),objScores(:,2),[repmat(' ',...
                             size(paretoScoreV)),num2str(paretoScoreV)],...
                             'fontsize',fs)
set(gca,'xlim',[0,max(objScores(:,1))],'ylim',[0,max(objScores(:,2))])
xlabel('first objective')
ylabel('second objective')
title('Vrugt et al. (2003) ranking')
set(gca,'xlim',[0,10],'ylim',[0,10])

disp('')
disp(' obj1  obj2 paretoScoreG paretoScoreZ paretoScoreV')
disp('')
disp(sprintf('%5.2f %5.2f %12.2f %12.2f %12.2f\n',...
            [objScores,paretoScoreG,paretoScoreZ,paretoScoreV]'))





