function writeGraphFiles(dataPath, trnSntNormX, trnSntNormY, trnSntX, trnSntY ...
                        , trnRcvNormX, trnRcvNormY, trnRcvX, trnRcvY ...
                        , tstSntNormX, tstSntNormY, tstSntX, tstSntY ...
                        , tstRcvNormX, tstRcvNormY, tstRcvX, tstRcvY ...
                        , trnNormSntIDs, tstNormSntIDs, trnSntIDs, tstSntIDs ...
                        , trnNormRcvIDs, tstNormRcvIDs, trnRcvIDs, tstRcvIDs)

%% Store all the graph data on disk as csv format
 
% Store training data sets of the graphs
trnSntNorm = [trnSntNormX,trnSntNormY];
trnSnt = [trnSntX,trnSntY];
trnRcvNorm = [trnRcvNormX,trnRcvNormY];
trnRcv = [trnRcvX,trnRcvY];
writeInCSV([dataPath 'trnSntNorm.csv'], trnSntNorm, 'graph');
writeInCSV([dataPath 'trnSnt.csv'], trnSnt, 'graph');
writeInCSV([dataPath 'trnRcvNorm.csv'], trnRcvNorm, 'graph');
writeInCSV([dataPath 'trnRcv.csv'], trnRcv, 'graph');

% Store testing data sets of the graphs
tstSntNorm = [tstSntNormX,tstSntNormY];
tstSnt = [tstSntX,tstSntY];
tstRcvNorm = [tstRcvNormX,tstRcvNormY];
tstRcv = [tstRcvX,tstRcvY];
writeInCSV([dataPath 'tstSntNorm.csv'], tstSntNorm, 'graph');
writeInCSV([dataPath 'tstSnt.csv'], tstSnt, 'graph');
writeInCSV([dataPath 'tstRcvNorm.csv'], tstRcvNorm, 'graph');
writeInCSV([dataPath 'tstRcv.csv'], tstRcv, 'graph');

% Store IDs of the training and the testing data sets
writeInCSV([dataPath 'trnNormSntIDs.csv'], trnNormSntIDs, 'graph');
writeInCSV([dataPath 'tstNormSntIDs.csv'], tstNormSntIDs, 'graph');
writeInCSV([dataPath 'trnSntIDs.csv'], trnSntIDs, 'graph');
writeInCSV([dataPath 'tstSntIDs.csv'], tstSntIDs, 'graph');

writeInCSV([dataPath 'trnNormRcvIDs.csv'], trnNormRcvIDs, 'graph');
writeInCSV([dataPath 'tstNormRcvIDs.csv'], tstNormRcvIDs, 'graph');
writeInCSV([dataPath 'trnRcvIDs.csv'], trnRcvIDs, 'graph');
writeInCSV([dataPath 'tstRcvIDs.csv'], tstRcvIDs, 'graph');

end