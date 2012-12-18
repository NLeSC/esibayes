

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

    sodaSubplotScreen(2,4,1)
    sodaSubplotScreen(1,4,2)
    sodaSubplotScreen(2,4,5)
    
    sodaSubplotScreen(1,2,2)
    
end

clear vTest1
clear vTest2
clear vTest3


figure(1)
clf
marghist(sodaPar,evalResults)

figure(2)
clf
plotgelmanrubin(sodaPar,critGelRub,'view','zoom')

figure(3)
clf
plotobj(sodaPar,evalResults)

figure(4)
clf
matrixofscatter(sodaPar,evalResults(:,:),'history','all',...
                            'color',[0.6,0.6,0.6],'holdon',true,...
                            'markersize',3)
matrixofscatter(sodaPar,evalResults,'history','lastgen','markersize',3)


drawnow