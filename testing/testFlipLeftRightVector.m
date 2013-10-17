function testFlipLeftRightVector()

% testFlipLeftRightVector Unit test for fliplr with vector input

in = [1,4,10];
outExpected = [10,4,1];

outActual = fliplr(in);

if ~isequal(outExpected,outActual)
    error('testFliplrVector:notEqual', 'Incorrect output for vector.');
end