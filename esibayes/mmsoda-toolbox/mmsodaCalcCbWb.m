function [Cb,Wb] = mmsodaCalcCbWb(conf)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcCbWb.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%
% This function calculates the parameters for the exponential power density
% Equation [20] paper by Thiemann et al. WRR 2001, Vol 37, No 10, 2521-2535
kurt = conf.kurt;

A1 = gamma(3*(1+kurt)/2); 
A2 = gamma((1+kurt)/2); 
Cb = (A1/A2)^(1/(1+kurt));
Wb = sqrt(A1)/((1+kurt)*(A2^(1.5)));


