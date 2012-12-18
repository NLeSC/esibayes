function sDraw = sodaStratRandDraw(conf)
%
% <a href="matlab:web(fullfile(sodaroot,'html','stratrand.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%

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

eval(['parCombs = sodaAllComb(',pStr,')+',...
    'repmat(res,[nStratRandSamples,1]).*',...
    'rand(nStratRandSamples,nOptPars);'])

% eval(['parCombs = allcomb(',pStr,')'])%.*',...
% %     'repmat(res,[nStratRandSamples,1]).*',...
% %     'rand(nStratRandSamples,nOptPars)'])


TMP=conf;
TMP.nSamples=nUniRandSamples;

uDraw = sodaUnifRandDraw(TMP,'parSpace');

sDraw=[parCombs;uDraw];

