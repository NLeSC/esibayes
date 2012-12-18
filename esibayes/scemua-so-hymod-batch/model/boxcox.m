function YT = boxcox(Y,lambda)

% see "http://en.wikipedia.org/wiki/Power_transform#Box.E2.80.93Cox_transformation"

if lambda~=0
    YT = (Y.^lambda-1)/lambda;
else
    YT = log(Y);
end