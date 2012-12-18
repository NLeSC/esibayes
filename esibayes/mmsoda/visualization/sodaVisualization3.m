


sodaSubplotScreen(2,2,1,'figureNumber',1004)
clf
sodaPlotSeq(conf,sequences,metropolisRejects,'plotMode','subaxes')




sodaSubplotScreen(2,2,3,'figureNumber',1003)
clf
if conf.isSingleObjective
    sodaMatrixOfScatter(conf,'obj-par',sequences,metropolisRejects,...
         'bgColor',[1,1,1]*0.7,'lightFactor','none','nHistory','H2')

elseif conf.isMultiObjective
    sodaMatrixOfScatter(conf,'par-pareto',sequences,metropolisRejects,...
         'bgColor',[1,1,1]*0.7,'lightFactor','none','nHistory','H2')
else
end

sodaSubplotScreen(1,2,2,'figureNumber',1001)
clf
sodaMargHist(conf,evalResults,'fixedBinEdges',false)



drawnow




