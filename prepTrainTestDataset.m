function [trnX, trnY, tstX, tstY, trnIDs, tstIDs] ...
    = prepTrainTestDataset(graph1, graph2, trnRatio, graph1IDs, graph2IDs)

% Sampling the larger matrices to make a balanced training set and test set
if size(graph1, 1) < size(graph2, 1)
    sampIdx = randperm(size(graph1, 1))';
    graph2 = graph2(sampIdx, :);
    graph2IDs = graph2IDs(sampIdx);
    sampIdx = randperm(size(graph1, 1))';
    graph1 = graph1(sampIdx, :);
    graph1IDs = graph1IDs(sampIdx);
else
    sampIdx = randperm(size(graph2, 1))';
    graph1 = graph1(sampIdx, :);
    graph1IDs = graph1IDs(sampIdx);
    sampIdx = randperm(size(graph2, 1))';
    graph2 = graph2(sampIdx, :);
    graph2IDs = graph2IDs(sampIdx);
end


%% For Random Forest
% Combine the two matrices and split them into the two data sets based on
% the given ratio
trnEdIdx = round(size(graph1,1) * trnRatio);

trnX = [graph1(1:trnEdIdx,:); graph2(1:trnEdIdx,:)];
trnIDs = [graph1IDs(1:trnEdIdx,:); graph2IDs(1:trnEdIdx,:)];
trnY = [ones(trnEdIdx, 1); ones(trnEdIdx, 1)*(-1)];
tstX = [graph1(trnEdIdx+1:end,:); graph2(trnEdIdx+1:end,:)];
tstIDs = [graph1IDs(trnEdIdx+1:end,:); graph2IDs(trnEdIdx+1:end,:)];
tstY = [ones(size(graph1, 1) - trnEdIdx + 1, 1); ...
            ones(size(graph1, 1) - trnEdIdx + 1, 1)*(-1)];

% Randomize each data set
sampIdx = randperm(size(trnX, 1))';
trnX = trnX(sampIdx, :);
trnIDs = trnIDs(sampIdx);
trnY = trnY(sampIdx, :);
sampIdx = randperm(size(tstX, 1))';
tstX = tstX(sampIdx, :);
tstIDs = tstIDs(sampIdx);
tstY = tstY(sampIdx, :);


%% For AdaBoost classifier
% posTrnX = trnX((trnY == 1), :);
% negTrnX = trnX((trnY == -1), :);

end
