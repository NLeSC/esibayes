parCols=1:MCMCPar.n;
lastRows = [-99:0]+size(Sequences,1);
parSets = [];
for iSeq=1:MCMCPar.seq
    parSets = cat(1,parSets,Sequences(lastRows,parCols,iSeq));
end

Extra.tObj = bound(:,1);
for k=1:size(parSets,1)
    parVec = parSets(k,:);
    ySim(k,:) = interceptionmodel(parVec,Extra);
end