function sDraw = mmsodaStratDraw(conf)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaStratDraw.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
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
% correct for numerical error:
%if (nSamplesPerAxis+1)^3<=nSamples
%    nSamplesPerAxis=nSamplesPerAxis+1;
%end


nStratSamples=nSamplesPerAxis^nOptPars;
nUniRandSamples = nSamples-nStratSamples;

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
    'repmat(res,[nStratSamples,1]).*',...
    '0.5.*ones(nStratSamples,nOptPars);'])

if nUniRandSamples>0
    disp(['Unable to distribute uniformly the number of samples. ',...
        num2str(nUniRandSamples),' samples have been assigned using',char(10),...
        'a uniform random distribution.'])
    parRange = conf.parSpaceHiBound-conf.parSpaceLoBound;
    uDraw = repmat(conf.parSpaceLoBound,[nUniRandSamples,1])+...
                rand(nUniRandSamples,conf.nOptPars).*...
                repmat(parRange,[nUniRandSamples,1]);
    sDraw = [parCombs;uDraw];
else
    sDraw = parCombs;
end


