dataFileRes = 'pop-res-data-ref.mat';
dataFilePop = 'pop-res-data-high-deathrate.mat';

% load only 'PopMeas' from 'dataFilePop':
load(dataFilePop,'PopMeas')

% load 'ResourceMeas' and 'tMeas' from 'dataFileRes':
load(dataFileRes,'ResourceMeas','tMeas')