function sDraw = sodaStratDraw(conf)
%
% <a href="matlab:web(fullfile(sodaroot,'html','sodaStratDraw.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>
%

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

eval(['parCombs = sodaAllComb(',pStr,')+',...
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


