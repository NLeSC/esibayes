function colorList = mmsodaMakeColors(conf)
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaMakeColorList.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


nSequences = conf.nCompl;


defaultColors = [0,0,1;...
    0,0.5,0;
    1,0,0;...
    1,0.5,0;...
    1,0.9,0;...
    0.5882,0.7216,0.1804;...
    0,1,1;...
    1,0,1;...
    0.7529,0.7529,0.7529;...
    0.1490,0.5333,0.7176];

nDefaultColors = size(defaultColors,1);

if nSequences>nDefaultColors
    cVec = linspace(0.1,0.9,ceil((nSequences-nDefaultColors)^(1/3)));
    extraColors = allcomb(cVec,cVec,cVec);
else
    extraColors=[];
end


colorList =[defaultColors;extraColors];