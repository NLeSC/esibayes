Ix = find(stor(:,2)>2.2);          % find the rows of the array 'stor' where 
                                   % storage is more than 2.2

Measurement.MeasData = stor(Ix,2); % Define the measured data

Extra.bound = bound;               % these are the boundary conditions (t,P,PE)
Extra.stor = stor;                 % these are the measurements of storage (t,S)
Extra.tObj = stor(Ix,1);           % the times at which measurements are available 
                                   % that are used in the objective function