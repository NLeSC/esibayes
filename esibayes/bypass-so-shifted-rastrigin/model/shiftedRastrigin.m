function objScore = shiftedRastrigin(conf,constants,modelOutput,parVec)
% 9.Shifted Rastrign's Function

mmsodaUnpack()

x = [x1,x2];

[ps,D]=size(x);

if D>100
    error('Too many dimensions')
end

x = x-repmat(o(1:D),ps,1);
objScore = -sum(x.^2-10.*cos(2.*pi.*x)+10,2);


