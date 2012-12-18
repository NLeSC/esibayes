

% test if this generation is the first after the initialization:
vTest1 = evalResults(end,sodaPar.iterCol)==sodaPar.nSamples+sodaPar.nOffspring;

% test if this generation id the first after a resume:
vTest2 = (exist('nRecords','var')==1 && nModelEvals == nRecords-nTrownAway);

% test if this script is called from the base workspace:
callStack = dbstack;
vTest3 = numel(callStack)==1;

if vTest1 || vTest2 || vTest3 
    
    % if any of these tests are true, organize the layout of the screen
    % according to:

    sodaSubplotScreen(2,4,1,'figureNumber',1)
    sodaSubplotScreen(1,4,2,'figureNumber',2)
    sodaSubplotScreen(2,4,5,'figureNumber',3)
    
    sodaSubplotScreen(1,2,2,'figureNumber',4)

end

clear vTest1
clear vTest2
clear vTest3


figure(1)
clf
sodaMargHist(sodaPar,evalResults)

figure(2)
clf
sodaPlotGelmanRubin(sodaPar,critGelRub,'view','full')

figure(3)
clf
sodaPlotObj(sodaPar,sequences,metropolisRejects)

figure(4)
clf
sodaPlotSeq(sodaPar,sequences,metropolisRejects,'plotMode','subaxes','checkered',true)

drawnow