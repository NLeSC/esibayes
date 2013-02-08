
% <a href="matlab:web(fullfile(mmsodaroot,'html','mmsodaVisualization3.html'),'-helpbrowser')">View HTML documentation for this function in the help browser</a>


mmsodaSubplotScreen(2,2,1,'figureNumber',1004)
clf
mmsodaPlotSeq(conf,sequences,metropolisRejects,'plotMode','subaxes')




mmsodaSubplotScreen(2,2,3,'figureNumber',1003)
clf
if conf.isSingleObjective
    mmsodaMatrixOfScatter(conf,'obj-par',sequences,metropolisRejects,...
         'bgColor',[1,1,1]*0.7,'lightFactor','none','nHistory','H2')

elseif conf.isMultiObjective
    mmsodaMatrixOfScatter(conf,'par-pareto',sequences,metropolisRejects,...
         'bgColor',[1,1,1]*0.7,'lightFactor','none','nHistory','H2')
else
end

mmsodaSubplotScreen(1,2,2,'figureNumber',1001)
clf
mmsodaMargHist(conf,evalResults,'fixedBinEdges',false)



drawnow




