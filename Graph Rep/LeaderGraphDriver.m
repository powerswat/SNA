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
ldrWeightedGraphs = genLdrsWeightedGraphs( ...
                            senders, recipients, weights, numSections);

% Save the set of graph data set in a csv format
graphPath = [basePath 'Leader Graph\'];
saveCSV(ldrWeightedGraphs, graphPath);

end














