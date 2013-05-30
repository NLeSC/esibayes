function [UT1,UT2,xn] = excess(x_loss,cmax,bexp,Pval,PETval);
% this function calculates excess precipitation and evaporation

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


xn_prev = x_loss;
ct_prev = cmax*(1-power((1-((bexp+1)*(xn_prev)/cmax)),(1/(bexp+1))));
UT1 = max((Pval-cmax+ct_prev),0.0);
Pval = Pval-UT1;
dummy = min(((ct_prev+Pval)/cmax),1);
xn = (cmax/(bexp+1))*(1-power((1-dummy),(bexp+1)));
UT2 = max(Pval-(xn-xn_prev),0);
evap = min(xn,PETval);
xn = xn-evap;

