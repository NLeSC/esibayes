function Y = unboxcox(YT,lambda)

% see http://en.wikipedia.org/wiki/Power_transform#Box.E2.80.93Cox_transformation

if lambda~=0
    Y = ((YT*lambda)+1).^(1/lambda);
else
    Y = exp(YT);
end