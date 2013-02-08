function subaxes(nRows,nCols,axesNumber,varargin)
% <a href="matlab:web(fullfile(mmsodaroot,'html','subaxes.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


borderLeft = 0.05;
borderRight = 0.0;
borderBottom = 0.05;
borderTop = 0.0;

spacingBottom = 0.05;
spacingLeft = 0.05;
spacingTop = 0.05;
spacingRight = 0.05;

AuthorizedOptions ={'border',...
                    'spacing',...
                    'borderLeft',...
                    'borderRight',...
                    'borderBottom',...
                    'borderTop',...
                    'spacingBottom',...
                    'spacingLeft',...
                    'spacingTop',...
                    'spacingRight'};

for k = 1:2:length(varargin(:))
    if ~strcmp(varargin{k}, AuthorizedOptions)
        s=dbstack;
        error(['Unauthorized parameter name ' 39 varargin{k} 39 ' in ' 10,...
            'parameter/value passed to ',39,s(end).name,39,'.']);
    end
    eval([varargin{k},'=varargin{',num2str(k+1),'};'])
end

if exist('spacing','var')==1
    spacingLeft = spacing;
    spacingRight = spacing;
    spacingTop = spacing;
    spacingBottom = spacing;
end

if exist('border','var')==1
    borderLeft = border;
    borderRight = border;
    borderTop = border;
    borderBottom = border;
end


axesHeight = (1-spacingBottom-spacingTop)/nRows-borderTop-borderBottom;
axesWidth = (1-spacingLeft-spacingRight)/nCols-borderRight-borderLeft;


colNumber = mod(axesNumber-1,nCols)+1;
rowNumber = 1+(axesNumber-colNumber)/nCols;

if ~(1<=colNumber && colNumber<=nCols)||...
        ~(1<=rowNumber && rowNumber<=nRows)

    error('Figure number out of bounds.')

end

axesLeft = ((colNumber-1)*(axesWidth+borderLeft+borderRight))+spacingLeft+borderLeft;
axesBottom = (nRows-rowNumber)*(axesHeight+borderBottom+borderTop)+spacingBottom+borderBottom;

axesHandle = axes('position',[axesLeft,axesBottom,axesWidth,axesHeight]);




if nargout==1 
    varargout=axesHandle;
end