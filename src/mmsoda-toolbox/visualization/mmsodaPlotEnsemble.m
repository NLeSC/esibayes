function varargout = mmsodaPlotEnsemble(conf,evalResults,metropolisRejects,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaPlotEnsemble.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

if nargin == 0
    fn = [mfilename('fullpath'),'.m'];
    fid = fopen(fn,'r');
    line = fgetl(fid);
    fclose(fid);
    disp('% Usage is: ')
    disp(['% ',line])
    disp('%')
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

replaceRejected = false;
showReplaceRejected = false;

authorizedOptions = {'normalizeByObs','stateStyle','colorObs','colorSim',...
                     'colorPost','connStyle','iParset','iMember','iStateKF',...
                     'connWidth','showLegend','showiMember','showiParset',...
                     'showiStateKF','replaceRejected','showReplaceRejected'};
mmsodaParsePairs()

% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 

evalNumbers = iParset;
vecMembers = iMember;
vecStatesKF = iStateKF;
vecPrior = 1:numel(conf.priorTimes);

clear iParset
clear iMember
clear iStateKF

nParsets = numel(evalNumbers);

if replaceRejected
    
    for ip=1:nParsets
        
        evalNumbers(ip) = mmsodaGetPrecedingAccepted(conf,metropolisRejects,evalNumbers(ip));
    end
    
end

[stateValuesKFPrior,stateValuesKFPert,stateValuesKFPost,obsPerturbed] = mmsodaRetrieveEnsembleData(conf,evalNumbers);



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
                    end %strcmp(conf.modeStr,'soda')

                    XObs = [XObs;repmat(NaN,[1,size(XObs,2)])];
                    YObs = [YObs;repmat(NaN,[1,size(YObs,2)])];
                end %conf.assimilate(iPrior)
            end %iPrior = vecPrior
        end %iStatesKF = vecStatesKF
    end %iMember = vecMembers
end %iParset = 1:nParsets


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
                else
                    H.obsPert = [];
                end
                H.statesPost = plot(conf.priorTimes(vecPrior),shiftdim(stateValuesKFPost(iParset,iMember,iStatesKF,vecPrior),3),...
                    stateStyle{:},'marker','^','markerfacecolor',colorPost,'markeredgecolor',colorPost);
        end
    end
end


appendSemicolon = false;
titleStr = '';
if showReplaceRejected
    titleStr = [titleStr,'replaceRejected = '];
    if replaceRejected
        titleStr = [titleStr,'true'];
    else
        titleStr = [titleStr,'false'];
    end
    appendSemicolon = true;
end
if showiParset
    % if isscalar(evalNumbers)
    %     titleStr = [titleStr,'parset = ',sprintf('%d; ',evalNumbers)];
    % else
    %     titleStr = [titleStr,'parsets = ',sprintf(['[',repmat('%d,',[1,numel(evalNumbers)-1]),'%d',']; '],evalNumbers)];
    % end
    if appendSemicolon 
        titleStr = [titleStr,'; '];
    end
    if isscalar(evalNumbers)
        titleStr = [titleStr,'parset = ',vectorMakeCompact(evalNumbers)];
    else
        titleStr = [titleStr,'parsets = ',vectorMakeCompact(evalNumbers)];
    end
    appendSemicolon = true;
end
if strcmp(conf.modeStr,'soda') && showiMember
    if appendSemicolon 
        titleStr = [titleStr,'; '];
    end
    if isscalar(vecMembers)
        titleStr = [titleStr,'member = ',sprintf('%d; ',vecMembers)];
    else
        titleStr = [titleStr,'members = ',sprintf(['[',repmat('%d,',[1,numel(vecMembers)-1]),'%d',']; '],vecMembers)];
    end
    appendSemicolon = true;
end
if conf.nStatesKF>1 && showiStateKF
    if appendSemicolon 
        titleStr = [titleStr,'; '];
    end
    if isscalar(vecStatesKF)
        titleStr = [titleStr,'state = ',sprintf('%d; ',vecStatesKF)];
    else
        titleStr = [titleStr,'states = ',sprintf(['[',repmat('%d,',[1,numel(vecStatesKF)-1]),'%d',']; '],vecStatesKF)];
    end
end

title(titleStr)


if showLegend
    if strcmp(conf.modeStr,'reset')
        legend([H.obs(1),H.statesPrior(1),H.statesPost(1)],...
            'obs','sim,prior','posterior')
    elseif strcmp(conf.modeStr,'soda')
        legend([H.obs(1),H.obsPert(1),H.statesPrior(1),H.statesPert(1),H.statesPost(1)],...
            'obs','obs,pert','sim,prior','sim,pert','posterior')
    else
    end
    
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




function s = vectorMakeCompact(v)

nv = numel(v);

if nv == 0
    s = '';
    return
end

from = v(1:nv-1);
to = v(2:nv);
isconsecutive = (to-from)==1;
s = num2str(v(1));
for iv = 2:nv
    
    if isconsecutive(iv-1)
        if iv==nv || ~isconsecutive(iv)
            s = [s,':',num2str(to(iv-1))];
        else
            
        end
    else
        s = [s,',',num2str(to(iv-1))];
    end
    
end
