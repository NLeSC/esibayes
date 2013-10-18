function testMmsodaPartComplexes()
% testMmsodaPartComplexes is a unit test for mmsodaPartComplexes


profile resume


evalResults = [21,22,23,24,25;...
               31,32,33,34,35;...
               51,52,53,54,55;...
               61,62,63,64,65;...
               11,12,13,14,15;...
               41,42,43,44,45];

conf.nCompl = 3;
conf.nSamplesPerCompl = 2;
conf.nSamples = 6;
conf.evalCol = 1;
conf.objCol = 5;

% complexes = mmsodaPartComplexes(conf,evalResults);

profile off


assertTrue(true);



