function testMmsodaCalcCbWb()
% testMmsodaCalcCbWb Unit test for mmsodaCalcCbWb 

disp(['in ',mfilename])

profile resume

conf.kurt = 0; % (normal distribution kurtosis)


[CbActual,WbActual] = mmsodaCalcCbWb(conf);


CbExpected = 0.5;
WbExpected = mvnpdf(0,0,1);

tolerance = 1e-10;

profile off


assertTrue(abs(CbActual-CbExpected)<tolerance);

assertTrue(abs(WbActual-WbExpected)<tolerance);



