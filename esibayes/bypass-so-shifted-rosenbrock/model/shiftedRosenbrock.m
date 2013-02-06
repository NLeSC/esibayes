function objScore = shiftedRosenbrock(conf,constants,modelOutput,parVec)
% 3.Shifted Rosenbrock Function

sodaUnpack()

x = [x1,x2];

[ps,D]=size(x);

if D>100
    error('Too many dimensions')
end


x = x-repmat(o(1:D),ps,1)+1;
objScore = -sum(100.*(x(:,1:D-1).^2-x(:,2:D)).^2+(x(:,1:D-1)-1).^2,2);

