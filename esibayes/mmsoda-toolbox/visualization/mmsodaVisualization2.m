
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaVisualization2.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>

mmsodaSubplotScreen(2,4,1,'figureNumber',1001)
clf
mmsodaMargHist(conf,evalResults)

mmsodaSubplotScreen(1,4,2,'figureNumber',1002)
clf
mmsodaPlotGelmanRubin(conf,critGelRub,'view','full')

mmsodaSubplotScreen(2,4,5,'figureNumber',1003)
clf
mmsodaMatrixOfScatter(conf,'eval-obj',sequences,metropolisRejects)

mmsodaSubplotScreen(1,2,2,'figureNumber',1004)
clf
mmsodaPlotSeq(conf,sequences,metropolisRejects,'plotMode','subaxes','checkered',false)

drawnow