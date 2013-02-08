function s=mmsodaroot
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaroot.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>



a = mfilename('fullpath');
Ix = findstr(a,filesep);
s = a(1:Ix(end-1));

