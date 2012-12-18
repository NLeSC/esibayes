function objScore = shiftedRastrigin(mConstants,allStateValuesKF,allValuesNOKF,parVec)
% 9.Shifted Rastrign's Function

% map the constants values to their respective variables:
for iConstant=1:size(mConstants,1)
    eval([mConstants{iConstant,1},'=mConstants{iConstant,2};'])
end

x = parVec;

[ps,D]=size(x);

if D>100
    error('Too many dimensions')
end

x = x-repmat(o(1:D),ps,1);
objScore = -sum(x.^2-10.*cos(2.*pi.*x)+10,2);


