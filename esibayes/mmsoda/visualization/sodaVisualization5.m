


sodaSubplotScreen(2,2,1,'figureNumber',1001)
clf
sodaMargHist(conf,evalResults)

sodaSubplotScreen(2,2,2,'figureNumber',1002)
clf
sodaPlotGelmanRubin(conf,critGelRub,'view','zoom')

sodaSubplotScreen(2,2,3,'figureNumber',1003)
clf
sodaMatrixOfScatter(conf,'eval-obj',sequences,metropolisRejects,'nHistory','all')

sodaSubplotScreen(2,2,4,'figureNumber',1004)
clf
sodaMatrixOfScatter(conf,'par-par',sequences,metropolisRejects)


drawnow
