function varargout = sodaPlotEnsemble(conf,stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed,varargin)

if nargin == 0
    disp(['% % Usage is:',char(10),'% %  varargout = sodaPlotEnsemble(conf,stateValuesKFPrior',...
        'stateValuesKFPert,stateValuesKFPost,obsPerturbed,varargin)'])
    return
end
normalizeByObs = false;
stateStyle = {'markersize',8,'markerfacecolor','none','linestyle','none'};
colorObs = [1,0,1];
colorSim = [0,0,0];
colorPost = [0,0.5,0];
connStyle = {'linewidth',1.5};
iParset = 1;
iMember = 1;
iStateKF = 1;

authorizedOptions = {'normalizeByObs','stateStyle','colorObs','colorSim',...
                     'colorPost','connStyle','iParset','iMember','iStateKF',...
                     'connWidth'};
sodaParsePairs()




[nParsets,nMembers,nStatesKF,nDASteps] = size(stateValuesKFPost);

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


vecParsets = iParset;
vecMembers = iMember;
vecStatesKF = iStateKF;
vecPrior = 1:numel(conf.priorTimes);

XSim = [];
YSim = [];
for iParset = vecParsets
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
for iParset = vecParsets
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

for iParset = vecParsets
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


if nargout == 1
    varargout{1} = H;
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


