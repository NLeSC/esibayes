function varargout = sodaPlotEnsemble(conf,evalResults,varargin)

if nargin == 0
    disp(['% % Usage is:',char(10),'% %  varargout = sodaPlotEnsemble(conf,stateValuesKFPrior,',...
        'stateValuesKFPert,stateValuesKFPost,obsPerturbed,varargin)'])
    return
end

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

normalizeByObs = false;
stateStyle = {'markersize',8,'markerfacecolor','none','linestyle','none'};
colorObs = [1,0,1];
colorSim = [0,0,0];
colorPost = [0,0.5,0];
connStyle = {'linewidth',1.5};
iParset = size(evalResults,1);
iMember = 1;
iStateKF = 1;
% iPrior = 1:conf.nPrior;
showLegend = true;
showiMember = true;
showiParset = true;
showiStateKF = true;

authorizedOptions = {'normalizeByObs','stateStyle','colorObs','colorSim',...
                     'colorPost','connStyle','iParset','iMember','iStateKF',...
                     'connWidth','showLegend','showiMember','showiParset','showiStateKF'};
sodaParsePairs()

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

vecParsets = iParset;
vecMembers = iMember;
vecStatesKF = iStateKF;
vecPrior = 1:numel(conf.priorTimes);

clear iParset
clear iMember
clear iStateKF


nParsets = numel(vecParsets);
nMembers = conf.nMembers;
nStatesKF = conf.nStatesKF;
nPrior = conf.nPrior;

nanArray = repmat(NaN,[nParsets,nMembers,nStatesKF,nPrior]);

stateValuesKFPrior = nanArray;
stateValuesKFPert = nanArray;
stateValuesKFPost = nanArray;
obsPerturbed = nanArray;

for ip=1:nParsets

    [tmp1,tmp2,tmp3,tmp4] = loadFromFile(conf,vecParsets(ip),evalResults);
       
    stateValuesKFPrior(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp1;
    stateValuesKFPert(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp2;
    stateValuesKFPost(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp3;
    obsPerturbed(ip,1:nMembers,1:nStatesKF,1:nPrior) = tmp4;

end




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 


if normalizeByObs
    normBy = repmat(shiftdim(conf.obsState,-2),[nParsets,nMembers,nStatesKF,1]);
    obsState = zeros(size(conf.obsState));
else
    normBy = 0;
    obsState = conf.obsState;
end

assimAtIx = find(conf.assimilate);

stateValuesKFPrior = stateValuesKFPrior-normBy;
stateValuesKFPert = stateValuesKFPert-normBy;
stateValuesKFPost = stateValuesKFPost-normBy;
obsPerturbed = obsPerturbed-normBy;


% vecParsets = 1:nParsets;
% vecMembers = iMember;
% vecStatesKF = iStateKF;
% vecPrior = 1:numel(conf.priorTimes);

XSim = [];
YSim = [];
for iParset = 1:nParsets
    for iMember = vecMembers
        for iStatesKF = vecStatesKF
            for iPrior = vecPrior

                % include priors
                XSim = [XSim;conf.priorTimes(iPrior)];
                YSim = [YSim;stateValuesKFPrior(iParset,iMember,iStatesKF,iPrior)];

                if conf.assimilate(iPrior)||iPrior==1
                    if strcmp(conf.modeStr,'soda')
                        % include connectors priors-priorPerturbed
                        x1 = conf.priorTimes(iPrior);
                        y1 = stateValuesKFPrior(iParset,iMember,iStatesKF,iPrior);
                        x2 = conf.priorTimes(iPrior);
                        y2 = stateValuesKFPert(iParset,iMember,iStatesKF,iPrior);
                        if ~(exist('connWidth','var')==1)
                            w = -0.45*find(iMember==vecMembers)/numel(vecMembers);
                        else
                            w = -connWidth;
                        end
                        [XConn,YConn] = calcConnectors(x1,y1,x2,y2,w);
                        XSim = [XSim;XConn];
                        YSim = [YSim;YConn];

                        % include connectors for priorPerts-posteriors
                        x1 = conf.priorTimes(iPrior);
                        y1 = stateValuesKFPert(iParset,iMember,iStatesKF,iPrior);
                        x2 = conf.priorTimes(iPrior);
                        y2 = stateValuesKFPost(iParset,iMember,iStatesKF,iPrior);
                        if ~(exist('connWidth','var')==1)
                            w = 0.45*find(iMember==vecMembers)/numel(vecMembers);
                        else
                            w = connWidth;
                        end
                        [XConn,YConn] = calcConnectors(x1,y1,x2,y2,w);
                        XSim = [XSim;XConn];
                        YSim = [YSim;YConn];
                    end
                    % include posteriors
                    XSim = [XSim;conf.priorTimes(1,iPrior)];
                    YSim = [YSim;stateValuesKFPost(iParset,iMember,iStatesKF,iPrior)];
                end
            end
            
            XSim = [XSim;repmat(NaN,[1,size(XSim,2)])];
            YSim = [YSim;repmat(NaN,[1,size(YSim,2)])];
        end
    end
end


XObs = [];
YObs = [];
for iParset = 1:nParsets
    for iMember = vecMembers
        for iStatesKF = vecStatesKF
            for iPrior = vecPrior


                if conf.assimilate(iPrior)
                    
                    iDAStep = sum(conf.assimilate(1:iPrior));
                    
                    % include observations
                    XObs = [XObs;conf.priorTimes(iPrior)];
                    YObs = [YObs;obsState(iDAStep)];


                    if strcmp(conf.modeStr,'soda')
                        % include connectors obs-obsPerturbed
                        x1 = conf.priorTimes(iPrior);
                        y1 = obsState(iDAStep);
                        x2 = conf.priorTimes(iPrior);
                        y2 = obsPerturbed(iParset,iMember,iStatesKF,iPrior);
                        if ~(exist('connWidth','var')==1)
                            w = -0.45*find(iMember==vecMembers)/numel(vecMembers);
                        else
                            w = -connWidth;
                        end
                        [XConn,YConn] = calcConnectors(x1,y1,x2,y2,w);
                        XObs = [XObs;XConn];
                        YObs = [YObs;YConn];

                        % include connectors for obsPerts-posteriors
                        x1 = conf.priorTimes(iPrior);
                        y1 = obsPerturbed(iParset,iMember,iStatesKF,iPrior);
                        x2 = conf.priorTimes(iPrior);
                        y2 = stateValuesKFPost(iParset,iMember,iStatesKF,iPrior);
                        if ~(exist('connWidth','var')==1)
                            w = 0.45*find(iMember==vecMembers)/numel(vecMembers);
                        else
                            w = connWidth;
                        end
                        [XConn,YConn] = calcConnectors(x1,y1,x2,y2,w);
                        XObs = [XObs;XConn];
                        YObs = [YObs;YConn];
                    end

                    XObs = [XObs;repmat(NaN,[1,size(XObs,2)])];
                    YObs = [YObs;repmat(NaN,[1,size(YObs,2)])];
                end
            end
        end
    end
end


H.connSim = plot(XSim,YSim,'-','color',whiten(colorSim,0),connStyle{:});
hold on
H.connObs = plot(XObs,YObs,'-','color',whiten(colorObs,0),connStyle{:});

for iParset = 1:nParsets
    for iMember = vecMembers
        for iStatesKF = vecStatesKF

                H.statesPrior = plot(conf.priorTimes(vecPrior),shiftdim(stateValuesKFPrior(iParset,iMember,iStatesKF,vecPrior),3),...
                    stateStyle{:},'marker','s','markeredgecolor',colorSim);
                if strcmp(conf.modeStr,'soda')
                    H.statesPert = plot(conf.priorTimes(vecPrior),shiftdim(stateValuesKFPert(iParset,iMember,iStatesKF,vecPrior),3),...
                        stateStyle{:},'marker','o','markeredgecolor',colorSim);
                end
                H.obs = plot(conf.obsStateTime,obsState,...
                    stateStyle{:},'marker','s','markeredgecolor',colorObs);
                if strcmp(conf.modeStr,'soda')
                    H.obsPert = plot(conf.priorTimes(vecPrior),shiftdim(obsPerturbed(iParset,iMember,iStatesKF,vecPrior),3),...
                        stateStyle{:},'marker','o','markeredgecolor',colorObs);
                end
                H.statesPost = plot(conf.priorTimes(vecPrior),shiftdim(stateValuesKFPost(iParset,iMember,iStatesKF,vecPrior),3),...
                    stateStyle{:},'marker','^','markerfacecolor',colorPost,'markeredgecolor',colorPost);
        end
    end
end



titleStr = '';
if showiParset
    if isscalar(vecParsets)
        titleStr = [titleStr,'parset = ',sprintf('%d; ',vecParsets)];
    else
        titleStr = [titleStr,'parsets = ',sprintf(['[',repmat('%d,',[1,numel(vecParsets)-1]),'%d',']; '],vecParsets)];
    end
end
if showiMember
    if isscalar(vecMembers)
        titleStr = [titleStr,'member = ',sprintf('%d; ',vecMembers)];
    else
        titleStr = [titleStr,'members = ',sprintf(['[',repmat('%d,',[1,numel(vecMembers)-1]),'%d',']; '],vecMembers)];
    end
end
if showiStateKF
    if isscalar(vecStatesKF)
        titleStr = [titleStr,'state = ',sprintf('%d; ',vecStatesKF)];
    else
        titleStr = [titleStr,'states = ',sprintf(['[',repmat('%d,',[1,numel(vecStatesKF)-1]),'%d',']; '],vecStatesKF)];
    end
end

title(titleStr)


if showLegend
    
    legend([H.obs(1),H.obsPert(1),H.statesPrior(1),H.statesPert(1),H.statesPost(1)],...
        'obs','obs,pert','sim,prior','sim,pert','posterior')
    
end


hold off

if nargout == 1
    varargout{1} = H;
elseif nargout == 2
    varargout{1} = H;
    varargout{2} = {'stateValuesKFPrior',tmp1;...
                     'stateValuesKFPert',tmp2;...
                     'stateValuesKFPost',tmp3;...
                     'obsPerturbed',tmp4};
else
    varargout = {};
end




% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                     % %
% %                          LOCAL FUNCTIONS                            % %
% %                                                                     % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %


function [xConn,yConn] = calcConnectors(x1,y1,x2,y2,w)

nSegments = 11;

if ~isrow(x1) || ~isvector(x1) 
    error('x1 should be a row vector')
end
if ~isrow(y1) || ~isvector(y1)
    error('y1 should be a row vector')
end
if ~isrow(x2) || ~isvector(x2) 
    error('x2 should be a row vector')
end
if ~isrow(y2) || ~isvector(y2)
    error('y2 should be a row vector')
end

if any(any(isnan([x1;y1;x2;y2])))
    xConn = [];
    yConn = [];
    return
end


dy = y2-y1;

xConnUnit = linspace(-1,1,nSegments)'.^2;
yConnUnit = linspace(-1,1,nSegments)';

xConn = (xConnUnit-1)*w+x1;
yConn = (yConnUnit+1)/2*dy+y1;




function colorOut = whiten(colorIn,degree)


colorOut = colorIn + degree*([1,1,1]-colorIn);


function [tmp1,tmp2,tmp3,tmp4] = loadFromFile(conf,iParset,evalResults)

start = [1,conf.nSamples+1:conf.nOffspring:size(evalResults,1)];
finish = [conf.nSamples,conf.nSamples+conf.nOffspring:conf.nOffspring:size(evalResults,1)];
ix = find((start<=iParset) & (iParset<=finish));
formatStr = './results/%s-results-enkf-evals-%d-%d.mat';
fn = sprintf(formatStr,conf.modeStr,start(ix),finish(ix));

try
    disp(sprintf('Loading parameter set %d from ''%s''.',iParset,fn))    
    load(fn,'stateValuesKFPrior','stateValuesKFPert','stateValuesKFPost','obsPerturbed')
catch err
    warning(sprintf('Error trying to load parameter set %d from ''%s''.',iParset,fn))
    rethrow(err)
end
    

s = iParset - start(ix) + 1;

tmp1 = stateValuesKFPrior(s,:,:,:);
tmp2 = stateValuesKFPert(s,:,:,:);
tmp3 = stateValuesKFPost(s,:,:,:);
tmp4 = obsPerturbed(s,:,:,:);


