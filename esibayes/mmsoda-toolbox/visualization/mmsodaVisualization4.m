% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaVisualization4.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>



mmsodaSubplotScreen(2,2,1,'figureNumber',1002)
clf
mmsodaPlotGelmanRubin(conf,critGelRub,'view','full')

mmsodaSubplotScreen(1,2,2,'figureNumber',1003)
clf
mmsodaMatrixOfScatter(conf,'par-par',sequences,metropolisRejects)

mmsodaSubplotScreen(2,2,3,'figureNumber',1004)
clf
mmsodaPlotSeq(conf,sequences,metropolisRejects,'plotMode','subaxes','checkered',false)



drawnow