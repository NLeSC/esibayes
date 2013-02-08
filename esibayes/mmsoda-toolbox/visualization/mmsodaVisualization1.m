

% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaVisualization1.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>



mmsodaSubplotScreen(1,2,1,'figureNumber',1004)
clf
mmsodaPlotGelmanRubin(conf,critGelRub)


mmsodaSubplotScreen(1,2,2,'figureNumber',1005)
clf
mmsodaMargHist(conf,evalResults)

drawnow
