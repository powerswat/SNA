function SNADriver

% Number of sections
numSections = 4;

%% Load all the data on memory
basePath = 'C:\Temp\Leadership data\';     % Base directory path
if ~exist([basePath 'input.mat'], 'file')
    [chatStrs, pstRtngs, posts, surveys, tpcViews, finNum, finStr, ...
        finNormNum, finNormStr, leaderList, graphs] = dataLoader(basePath);
    save([basePath 'input.mat']);
else
    load([basePath 'input.mat']);
end


%% Histogram
% Get numeric timestamp data
[chatTSs] = getTimeStamps(chatStrs, numSections, 2, 5);

% % Represent an overall histogram for all the four dicussion data based on
% % a daily scale
% [histInfoSt] = VizOverall(chatTSs, numSections);
% 
% % Organize everyone's posting data
% OrgIndvData(chatStrs, chatTSs, numSections, histInfoSt);


%% Classification
%   1. Messaging patterns of the leaders and the followers
%       - TODO: Classify with the transposed training and testing matrices
%   2. Generate feature vectors on the leaders' and followers text data and
%      classify them
%   3. Message viewing patterns of the leaders and followers
%   4. Behaving patterns of the leaders and followers on the website

% Generate a lookup table
idxCell = cell(4, 1);
idxCell(1) = strtrim({finStr(2:end,5)});
idxCell(2) = {finNum(:,4)};
idxCell(3) = {finNum(:,1)};

idxCell(4) = {finNum(:,2)};
unqSec = unique(idxCell{4}, 'stable');
for i=1:length(unqSec)
    curSecIdcs = find(idxCell{4} == unqSec(i));
    idxCell{4}(curSecIdcs) = i;
end

[nameUidGidSidTbl] = genLookUpTable(idxCell);

% Split the leaders' data and the followers' data
% TODO: Need to check the necessity of sepearting the leaders with the same
% ID in different sections
% [ldrChats, fllChats] = splitCellTwoGroups(chatStrs, leaderList, ...
%                         nameUidGidSidTbl, 2, numSections, 2, 5);
% [ldrPosts, fllPosts] = splitCellTwoGroups(posts, leaderList, ...
%                         nameUidGidSidTbl, 4, numSections, 2, 8);
% [ldrTpcVws, fllTpcVws] = splitCellTwoGroups(tpcViews, leaderList, ...
%                         nameUidGidSidTbl, 1, numSections, 2, 4);
% [ldrPstRtn, fllPstRtn] = splitCellTwoGroups(pstRtngs, leaderList, ...
%                         nameUidGidSidTbl, 1, numSections, 2, 4);
                    
% Split the leaders' graph and the followers' graph
[ldrGraphs, fllGraphs] = splitGraphTwoGroups(graphs, leaderList, nameUidGidSidTbl, 0);
[ldrNormGraphs, fllNormGraphs] = splitGraphTwoGroups( ...
                                    graphs, leaderList, nameUidGidSidTbl, 1);

% Prepare training and testing data sets
trnRatio = 0.9;
[trnX, trnY, tstX, tstY, posTrnX, negTrnX] = prepTrainTestDataset(ldrGraphs, fllGraphs, trnRatio);
[trnNormX, trnNormY, tstNormX, tstNormY, posNormTrnX, negNormTrnX] ...
                = prepTrainTestDataset(ldrNormGraphs, fllNormGraphs, trnRatio);
   

%% Classification using Random Forest
% Test on the testing dataset
leaf = 10;      % Tree size
nTrees = 25;    % Number of trees
b = TreeBagger(nTrees, trnX, trnY, 'OOBPred', 'on', 'MinLeaf', leaf);
bNorm = TreeBagger(nTrees, trnNormX, trnNormY, 'OOBPred', 'on', 'MinLeaf', leaf);
% view(bNorm.Trees{1})

prd = b.predict(tstX);
yNew = str2num(char(prd));
prdNorm = bNorm.predict(tstNormX);
yNormNew = str2num(char(prdNorm));

accuRF = sum(yNew == tstY) / length(tstY);
accuNormRF = sum(yNormNew == tstNormY) / length(tstNormY);

% Display the testing accuracy
disp('Testing Accuracy (Random Forest, Raw) = ');
disp(num2str(accuRF));
disp('Testing Accuracy (Random Forest, Norm) = ');
disp(num2str(accuNormRF));


%% Classfication using a boosted decision tree (Adaboost)
fp = 0;
fpNorm = 0;
while fp < 0.9 && fpNorm < 0.9
    % Prepare training and testing data sets
    trnRatio = 0.9;
    [trnX, trnY, tstX, tstY, posTrnX, negTrnX] = prepTrainTestDataset(ldrGraphs, fllGraphs, trnRatio);
    [trnNormX, trnNormY, tstNormX, tstNormY, posNormTrnX, negNormTrnX] ...
                    = prepTrainTestDataset(ldrNormGraphs, fllNormGraphs, trnRatio);

    model = adaBoostTrain(negTrnX, posTrnX);
    modelNorm = adaBoostTrain(negNormTrnX, posNormTrnX);

    fp = mean(adaBoostApply( tstX(tstY == 1,:), model )>0);
    fn = mean(adaBoostApply( tstX(tstY == -1,:), model )<0);
    accuBT = (fp + fn) / 2;

    fpNorm = mean(adaBoostApply( tstNormX(tstNormY == 1,:), modelNorm )>0);
    fnNorm = mean(adaBoostApply( tstNormX(tstNormY == -1,:), modelNorm )<0);
    accuNormBT = (fpNorm + fnNorm) / 2;

    % Display the testing accuracy
    disp('Testing Accuracy (Boosted, Raw) = ');
    disp(num2str(accuBT));
    disp('Testing Accuracy (Boosted, Norm) = ');
    disp(num2str(accuNormBT));
end

% Temp: To derive the most influential criteria
vars = cell(size(trnX,2),1);
for i=1:size(trnX,2)
    vars{i} = num2str(i);
end
% tree = classregtree(trnX, trnY, 'method', 'classification', ...
%     'names', vars, 'prune', 'off');
% view(tree);
treeNorm = classregtree(trnNormX, trnNormY, 'method', 'classification', ...
    'names', vars, 'prune', 'off');
view(treeNorm);

end