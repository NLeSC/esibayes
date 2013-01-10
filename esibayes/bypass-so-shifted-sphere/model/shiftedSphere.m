function objScore = shiftedSphere(conf,constants,allStateValuesKF,allValuesNOKF,parVec)
% 1.Shifted Sphere Function 

sodaUnpack()

x = [x1,x2];

[ps,D]=size(x);

if D>100
    error('Too many dimensions')
end

x=x-repmat(o(1:D),ps,1);
objScore=sum(x.^2,2);
