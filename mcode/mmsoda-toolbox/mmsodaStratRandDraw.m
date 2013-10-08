function sDraw = mmsodaStratRandDraw(conf)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaStratRandDraw.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
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


nOptPars = conf.nOptPars;
nSamples = conf.nSamples;

nSamplesPerAxis = floor(nSamples^(1/nOptPars));
nStratRandSamples=nSamplesPerAxis^nOptPars;
nUniRandSamples = nSamples-nStratRandSamples;

pStr='';


res(1,:) = (conf.parSpaceHiBound-conf.parSpaceLoBound)/(nSamplesPerAxis);

for k=1:numel(conf.parSpaceHiBound)
    eval(['p',num2str(k),' = linspace(conf.parSpaceLoBound(k),',...
                'conf.parSpaceHiBound(k)-res(k),',...
                'nSamplesPerAxis);'])

    if k<=1
        pStr = [pStr,'p',num2str(k)];
    else
        pStr = [pStr,',p',num2str(k)];
    end
        
end

eval(['parCombs = mmsodaAllComb(',pStr,')+',...
    'repmat(res,[nStratRandSamples,1]).*',...
    'rand(nStratRandSamples,nOptPars);'])

% eval(['parCombs = allcomb(',pStr,')'])%.*',...
% %     'repmat(res,[nStratRandSamples,1]).*',...
% %     'rand(nStratRandSamples,nOptPars)'])


TMP=conf;
TMP.nSamples=nUniRandSamples;

uDraw = mmsodaUnifRandDraw(TMP,'parSpace');

sDraw=[parCombs;uDraw];

