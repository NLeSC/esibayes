% You can save the variables from the workspace with:
save('dream-results.mat','MCMCPar','Sequences','ParRange',...
                         'Extra','ModelName')

% and figures can be saved to a PNG file using:
figure(123)
print('model-prediction.png','-dpng','-r300')