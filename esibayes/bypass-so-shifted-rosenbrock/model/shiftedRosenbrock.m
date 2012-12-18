function objScore = shiftedRosenbrock(mConstants,allStateValuesKF,allValuesNOKF,parVec)
% 3.Shifted Rosenbrock Function

% map the constants values to their respective variables:
for iConstant=1:size(mConstants,1)
    eval([mConstants{iConstant,1},'=mConstants{iConstant,2};'])
end

x = parVec;

[ps,D]=size(x);

if D>100
    error('Too many dimensions')
end


x = x-repmat(o(1:D),ps,1)+1;
objScore = -sum(100.*(x(:,1:D-1).^2-x(:,2:D)).^2+(x(:,1:D-1)-1).^2,2);

