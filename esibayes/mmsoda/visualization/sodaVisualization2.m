

sodaSubplotScreen(2,4,1,'figureNumber',1001)
clf
sodaMargHist(conf,evalResults)

sodaSubplotScreen(1,4,2,'figureNumber',1002)
clf
sodaPlotGelmanRubin(conf,critGelRub,'view','full')

sodaSubplotScreen(2,4,5,'figureNumber',1003)
clf
sodaMatrixOfScatter(conf,'eval-obj',sequences,metropolisRejects)

sodaSubplotScreen(1,2,2,'figureNumber',1004)
clf
sodaPlotSeq(conf,sequences,metropolisRejects,'plotMode','subaxes','checkered',false)

drawnow