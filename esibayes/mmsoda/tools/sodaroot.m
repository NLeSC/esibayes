function s=sodaroot
% <a href="matlab:web(fullfile(newscem_root,'html','license.html'),'-helpbrowser')">show license statement</a> 
%
a=mfilename('fullpath');
Ix=findstr(a,filesep);
s=a(1:Ix(end-1));

