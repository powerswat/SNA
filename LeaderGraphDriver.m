function LeaderGraphDriver

% Generate the communication network graph weighted by the leadership
% probability

% Set up paths for the base and data directories
basePath = 'C:\Temp\Leadership data\';          % Base directory path
dataPath = [basePath 'Leader Follower Data\'];  % Leader/Follower data path
probPath = [basePath 'SNA DATA\prob_data\'];    % Leader/Follower data path

% Load all the leadership data on disk
if ~exist([basePath 'input.mat'], 'file')
    [chatStrs, pstRtngs, posts, surveys, tpcViews, finNum, finStr, ...
        finNormNum, finNormStr, leaderList, graphs] = dataLoader(basePath);
    save([basePath 'input.mat']);
else
    load([basePath 'input.mat']);
end
[~, ~, rawLdrProb] = xlsread([probPath 'ldr_post_prob.xlsx']);
[~, ~, rawFllProb] = xlsread([probPath 'fll_post_prob.xlsx']);

numSections = size(posts,1);

% Locate the data for senders, recipients, post ids
senderCol = 4;
postIDCol = 1;
replyMsgCol = 29;
tsCol = 9;

% Generate a list of starting/ending timestamps per chapter
chapterTSs = getChapterTSs(numSections, leaderList);

% Organize the raw data indices by chater of each section
idcs = getIndcsPerCH(posts, tsCol, numSections, chapterTSs);

% Organize the message senders by chapter of each section
senders = getDataByCH(posts, senderCol, numSections, idcs);

% Organize the message IDs by chapter of each section
msgIDs = getDataByCH(posts, postIDCol, numSections, idcs);

% Organize the leadership probabilities by chapter of each section
postsWithWeights = [rawLdrProb(2:end,:); rawFllProb(2:end,:)];
weights = getWeights(postsWithWeights, numSections, ...
                size(postsWithWeights, 2), posts, idcs, postIDCol, tsCol);

% Organize the message recipients by chapter of each section
recipients = getRecipients(posts, replyMsgCol, senderCol, numSections, idcs, postIDCol);

% Generate a set of leaders' message graph data set for each chapter 
% in each section.
ldrWeightedGraphs = genLdrsWeightedGraphs()

% Save the set of graph data set in a csv format
saveCSV(ldrWeightedGraphs);

end


% Generate a list of starting/ending timestamps per chapter
function [chapterTSs] = getChapterTSs(numSections, leaderList)

chapterTSs = cell(numSections, 1);

for i=1:numSections
    numChapters = max(cell2mat(leaderList{i}(2:end, 2)));
    chapterTS = zeros(numChapters, 2);
    chapterTS(:,1) = sort(unique(datenum(leaderList{i}(2:end,3))));
    chapterTS(:,2) = sort(unique(datenum(leaderList{i}(2:end,4))));
    chapterTSs{i} = chapterTS;
end

end


% Organize the raw data indices by chater of each section
function [idcs] = getIndcsPerCH(posts, tsRow, numSections, chapterTSs)

idcs = cell(numSections, 1);
for i=1:numSections
    numChapters = size(chapterTSs{i},1);
    idcs{i} = cell(numChapters, 1);
    curCHPostTS = datenum(posts{i}(2:end, tsRow));
    for j=1:numChapters
         stTime = chapterTSs{i}(j,1);
         edTime = chapterTSs{i}(j,2);
         curCHIdcs = find(bsxfun(@plus, curCHPostTS >= stTime, ...
                                curCHPostTS <= edTime) == 2);
         idcs{i}(j) = {curCHIdcs}; 
    end
end

end


% Organize the targeted data by chapter of each section
function [data] = getDataByCH(posts, tgtCol, numSections, idcs)

data = cell(numSections,1);
for i=1:numSections
    numChapters = size(idcs{i},1);
    data{i} = cell(numChapters,1);
    for j=1:numChapters
        tmpCHData = posts{i}(idcs{i}{j}, tgtCol);
        if j==1
            tmpCHData(1) = [];
        end
        curCHSenders = cellfun(@str2num, tmpCHData);
        data{i}(j) = {curCHSenders};
    end
end

end


% Organize the message recipients by chapter of each section
function [recipients] = getRecipients( ...
                posts, replyMsgCol, senderCol, numSections, idcs, postIDCol)
                
recipients = cell(numSections,1);
for i=1:numSections
    numChapters = size(idcs{i},1);
    recipients{i} = cell(numChapters,1);
    msgIDs = posts{i}(:,1);
    msgIDs(1) = [];
    msgIDs = cellfun(@str2num, msgIDs);
    for j=1:numChapters
        tmpReplyMsgIDs = posts{i}(idcs{i}{j}, replyMsgCol);
        if j==1
            tmpReplyMsgIDs(1) = [];
        end
        
        replyMsgIDs = cellfun(@str2num, tmpReplyMsgIDs);
        senderIDs = cellfun(@str2num, posts{i}(2:end, senderCol));
        lenRow = size(replyMsgIDs,1);
        recipients{i}{j} = zeros(lenRow,1);
        for k=1:lenRow
            if replyMsgIDs(k) == -1
                recipients{i}{j}(k) = -1;
            else
                recipients{i}{j}(k) = senderIDs((msgIDs == replyMsgIDs(k)));
            end
        end
    end
end

end


% Organize the leadership probabilities by chapter of each section
function [weights] = getWeights(postsWithWeights, numSections, ...
                                    tgtCol, posts, idcs, postIDCol, tsCol)

weights = cell(numSections,1);
for i=1:numSections
    numChapters = size(idcs{i},1);
    weights{i} = cell(numChapters,1);
    for j=1:numChapters
        if j==1
            curCHPostIDSets = posts{i}(idcs{i}{j}(2:end),1:2);
        else
            curCHPostIDSets = posts{i}(idcs{i}{j},1:2);
        end
        
        curCHLen = size(curCHPostIDSets,1);
        weights{i}{j} = zeros(curCHLen,1);
        for k=1:curCHLen
            wghtRowIdcs = cell(size(curCHPostIDSets,2), 1);
            wghtRowIdcs(1) = {find(str2num(curCHPostIDSets{k,1}) ...
                                    == cell2mat(postsWithWeights(:,1)))};
            if length(wghtRowIdcs{1}) == 1
                weights{i}{j}(k) = postsWithWeights{wghtRowIdcs{1}, tgtCol};
            else
                wghtRowIdcs(2) = {find(str2num(curCHPostIDSets{k,2}) ...
                                    == cell2mat(postsWithWeights(:,2)))};
                finalIdx = intersect(wghtRowIdcs{1}, wghtRowIdcs{2});
                if ~isempty(finalIdx)
                    weights{i}{j}(k) = postsWithWeights{finalIdx, tgtCol}; 
                else
                    weights{i}{j}(k) = -1;
                end
            end
        end
    end
end

end


% Generate a set of leaders' message graph data set for each chapter 
% in each section.
function [ldrWeightedGraphs] = genLdrsWeightedGraphs()
end


% Save the set of graph data set in a csv format
function saveCSV(ldrWeightedGraphs)
end