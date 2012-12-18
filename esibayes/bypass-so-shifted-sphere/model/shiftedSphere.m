function objScore = calcLikelihood(mConstants,allStateValuesKF,allValuesNOKF,parVec)
% 1.Shifted Sphere Function 

% map the constants values to their respective variables:
for iConstant=1:size(mConstants,1)
    eval([mConstants{iConstant,1},'=mConstants{iConstant,2};'])
end


x = parVec;

[ps,D]=size(x);

if D>100
    error('Too many dimensions')
end

x=x-repmat(o(1:D),ps,1);
objScore=sum(x.^2,2);
