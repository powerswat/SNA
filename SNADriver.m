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
[ldrPosts, fllPosts] = splitCellTwoGroups(posts, leaderList, ...
                        nameUidGidSidTbl, 4, numSections, 2, 8);
% [ldrTpcVws, fllTpcVws] = splitCellTwoGroups(tpcViews, leaderList, ...
%                         nameUidGidSidTbl, 1, numSections, 2, 4);
% [ldrPstRtn, fllPstRtn] = splitCellTwoGroups(pstRtngs, leaderList, ...
%                         nameUidGidSidTbl, 1, numSections, 2, 4);
                    
% Split the original graph into leaders' and followers' sent graph
[ldrSntGraphs, fllSntGraphs] = splitGraphTwoGroups(graphs, leaderList, nameUidGidSidTbl, 0, 0);
[ldrNormSntGraphs, fllNormSntGraphs] = splitGraphTwoGroups( ...
                                    graphs, leaderList, nameUidGidSidTbl, 1, 0);

% Split the original graph into leaders' and followers' received graph                                
[ldrRcvGraphs, fllRcvGraphs] = splitGraphTwoGroups(graphs, leaderList, nameUidGidSidTbl, 0, 1);
[ldrNormRcvGraphs, fllNormRcvGraphs] = splitGraphTwoGroups( ...
                                    graphs, leaderList, nameUidGidSidTbl, 1, 1);

% Prepare training and testing data sets on sent messages
trnRatio = 0.9;
[trnSntX, trnSntY, tstSntX, tstSntY, posTrnSntX, negTrnSntX] ...
                = prepTrainTestDataset(ldrSntGraphs, fllSntGraphs, trnRatio);
[trnSntNormX, trnSntNormY, tstSntNormX, tstSntNormY, posNormTrnSntX, negNormTrnSntX] ...
                = prepTrainTestDataset(ldrNormSntGraphs, fllNormSntGraphs, trnRatio);
            
 % Prepare training and testing data sets on received messages
[trnRcvX, trnRcvY, tstRcvX, tstRcvY, posTrnRcvX, negTrnRcvX] ...
                = prepTrainTestDataset(ldrRcvGraphs, fllRcvGraphs, trnRatio);
[trnRcvNormX, trnRcvNormY, tstRcvNormX, tstRcvNormY, posRcvNormTrnX, negRcvNormTrnX] ...
                = prepTrainTestDataset(ldrNormRcvGraphs, fllNormRcvGraphs, trnRatio);
   

%% Classification using Random Forest
% Test on the testing dataset
leaf = 10;      % Tree size
nTrees = 25;    % Number of trees
b = TreeBagger(nTrees, trnSntX, trnSntY, 'OOBPred', 'on', 'MinLeaf', leaf);
bNorm = TreeBagger(nTrees, trnSntNormX, trnSntNormY, 'OOBPred', 'on', 'MinLeaf', leaf);
% view(bNorm.Trees{1})

prd = b.predict(tstSntX);
yNew = str2num(char(prd));
prdNorm = bNorm.predict(tstSntNormX);
yNormNew = str2num(char(prdNorm));

accuRF = sum(yNew == tstSntY) / length(tstSntY);
accuNormRF = sum(yNormNew == tstSntNormY) / length(tstSntNormY);

% Display the testing accuracy
disp('Testing Accuracy (Random Forest, Raw) = ');
disp(num2str(accuRF));
disp('Testing Accuracy (Random Forest, Norm) = ');
disp(num2str(accuNormRF));


%% Classfication using a boosted decision tree (Adaboost)
% AdaBoost analysis on sent messages
[modelSnt, accuBTSnt, tpSnt, tnSnt] = runAdaBoost(ldrSntGraphs, fllSntGraphs)
[modelNormSnt, accuNormBTSnt, tpNormSnt, tnNormSnt] = runAdaBoost(ldrNormSntGraphs, fllNormSntGraphs)

% AdaBoost analysis on received messages
[modelRcv, accuBTRcv, tpRcv, tnRcv] = runAdaBoost(ldrRcvGraphs, fllRcvGraphs)
[modelNormRcv, accuNormBTRcv, tpNormRcv, tnNormRcv] = runAdaBoost(ldrNormRcvGraphs, fllNormRcvGraphs)

% % Temp: To derive the most influential criteria
% vars = cell(size(trnSntX,2),1);
% for i=1:size(trnSntX,2)
%     vars{i} = num2str(i);
% end
% treeSntNorm = classregtree(trnSntNormX, trnSntNormY, 'method', 'classification', ...
%     'names', vars, 'prune', 'off');
% view(treeSntNorm);

% Temp: To derive the most influential criteria
vars = cell(size(trnRcvX,2),1);
for i=1:size(trnRcvX,2)
    vars{i} = num2str(i);
end
treeRcvNorm = classregtree(trnRcvNormX, trnRcvNormY, 'method', 'classification', ...
    'names', vars, 'prune', 'off');
view(treeRcvNorm);


end