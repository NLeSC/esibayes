
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaVisualization5.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


mmsodaSubplotScreen(2,2,1,'figureNumber',1001)
clf
mmsodaMargHist(conf,evalResults)

mmsodaSubplotScreen(2,2,2,'figureNumber',1002)
clf
mmsodaPlotGelmanRubin(conf,critGelRub,'view','zoom')

mmsodaSubplotScreen(2,2,3,'figureNumber',1003)
clf
mmsodaMatrixOfScatter(conf,'eval-obj',sequences,metropolisRejects,'nHistory','all')

mmsodaSubplotScreen(2,2,4,'figureNumber',1004)
clf
mmsodaMatrixOfScatter(conf,'par-par',sequences,metropolisRejects)


drawnow
