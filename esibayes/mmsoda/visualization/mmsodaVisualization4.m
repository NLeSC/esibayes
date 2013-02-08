

% if evalResults(end,sodaPar.iterCol)==sodaPar.nSamples+sodaPar.nOffspring
% %     RECT=[1,38,1280,800];
% % 
% %     sodaSubplotScreen(1,4,1,'rect',RECT)
% %     sodaSubplotScreen(1,4,2,'rect',RECT)
% %     sodaSubplotScreen(1,2,2,'rect',RECT)
% 
% 
%     sodaSubplotScreen(1,2,2)
%     sodaSubplotScreen(2,2,3)
%     
% end
% 
% 
% sodaSubplotScreen(2,2,1,'figureNumber',1004)
% clf
% plotgelmanrubin(sodaPar,critGelRub)
% 
% figure(2)
% matrixofscatter(sodaPar,evalResults(:,:),'history','all',...
%                             'color',[0.8,0.8,0.8],'holdon',true,...
%                             'markersize',2)
% matrixofscatter(sodaPar,evalResults,'history','lastgen','markersize',2)
% 
% 
% figure(3)
% clf
% plotseq(sodaPar,sequences,'subplots')



% sodaSubplotScreen(2,4,1,'figureNumber',1001)
% clf
% sodaMargHist(conf,evalResults)

sodaSubplotScreen(2,2,1,'figureNumber',1002)
clf
sodaPlotGelmanRubin(conf,critGelRub,'view','full')

sodaSubplotScreen(1,2,2,'figureNumber',1003)
clf
sodaMatrixOfScatter(conf,'par-par',sequences,metropolisRejects)

sodaSubplotScreen(2,2,3,'figureNumber',1004)
clf
sodaPlotSeq(conf,sequences,metropolisRejects,'plotMode','subaxes','checkered',false)



drawnow