function testFlipLeftRightMatrix
%testFlipLeftRightMatrix Unit test for fliplr with matrix input

in = magic(3);

outExpected = in(1:3,[3,2,1]);

outActual = fliplr(in);


assertEqual(outActual,outExpected);