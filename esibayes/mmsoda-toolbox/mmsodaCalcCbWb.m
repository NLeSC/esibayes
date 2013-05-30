function [Cb,Wb] = mmsodaCalcCbWb(conf)
%
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaCalcCbWb.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>    
%
% This function calculates the parameters for the exponential power density
% Equation [20] paper by Thiemann et al. WRR 2001, Vol 37, No 10, 2521-2535

% % 

% % LICENSE START
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% %                                                                           % %
% % MMSODA Toolbox for MATLAB                                                 % %
% %                                                                           % %
% % Copyright (C) 2013 Netherlands eScience Center                            % %
% %                                                                           % %
% % Licensed under the Apache License, Version 2.0 (the "License");           % %
% % you may not use this file except in compliance with the License.          % %
% % You may obtain a copy of the License at                                   % %
% %                                                                           % %
% % http://www.apache.org/licenses/LICENSE-2.0                                % %
% %                                                                           % %
% % Unless required by applicable law or agreed to in writing, software       % %
% % distributed under the License is distributed on an "AS IS" BASIS,         % %
% % WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  % %
% % See the License for the specific language governing permissions and       % %
% % limitations under the License.                                            % %
% %                                                                           % %
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %
% % LICENSE END



kurt = conf.kurt;

A1 = gamma(3*(1+kurt)/2); 
A2 = gamma((1+kurt)/2); 
Cb = (A1/A2)^(1/(1+kurt));
Wb = sqrt(A1)/((1+kurt)*(A2^(1.5)));


