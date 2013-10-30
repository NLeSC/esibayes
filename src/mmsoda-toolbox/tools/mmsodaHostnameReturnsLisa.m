function isLisa = mmsodaHostnameReturnsLisa()

[status,msg] = system('hostname');
isLisa = strcmp(msg(end-16:end-1),'lisa.surfsara.nl');