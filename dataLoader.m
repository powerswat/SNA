function [chatStrs, pstRtngs, posts, surveys, tpcViews, finNum, finStr, ...
    finNormNum, finNormStr, leaderList, graphs] = dataLoader(basePath)

% Number of sections
numSections = 4;

%% Read the chat data
chatPaths = cell(numSections,1);
chatPaths(1) = {'SNA DATA\Original Data\2009-01-01\2009_01_01_idiscuss_chat.xlsx'};
chatPaths(2) = {'SNA DATA\Original Data\2009-01-501\tkt4803_2009_01_501_idiscuss_chat.xlsx'};
chatPaths(3) = {'SNA DATA\Original Data\2010-01-01\tkt4803_2010_01_01_idiscuss_chat.xlsx'};
chatPaths(4) = {'SNA DATA\Original Data\2010-01-501\tkt4803_2010_01_501_idiscuss_chat.xlsx'};

chatStrs = cell(numSections,1);
for i=1:numSections
    [~, chatStr] = xlsread([basePath char(chatPaths(i))]);
    chatStrs(i) = {chatStr};
end


%% Read the post rating data
pstRtngsPaths = cell(numSections, 1);
pstRtngsPaths(1) = {'SNA DATA\Original Data\2009-01-01\2009_01_01_idiscuss_post_ratings.xlsx'};
pstRtngsPaths(2) = {'SNA DATA\Original Data\2009-01-501\tkt4803_2009_01_501_idiscuss_post_ratings.xlsx'};
pstRtngsPaths(3) = {'SNA DATA\Original Data\2010-01-01\tkt4803_2010_01_01_idiscuss_post_ratings.xls'};
pstRtngsPaths(4) = {'SNA DATA\Original Data\2010-01-501\tkt4803_2010_01_501_idiscuss_post_ratings.xls'};

pstRtngs = cell(numSections,1);
for i=1:numSections
    [~, pstRtngsStr] = xlsread([basePath char(pstRtngsPaths(i))]);
    pstRtngs(i) = {pstRtngsStr};
end


%% Read the posting data
postPaths = cell(numSections, 1);
postPaths(1) = {'SNA DATA\Original Data\2009-01-01\2009_01_01_posts.xlsx'};
postPaths(2) = {'SNA DATA\Original Data\2009-01-501\tkt4803_2009_01_501_posts.xlsx'};
postPaths(3) = {'SNA DATA\Original Data\2010-01-01\tkt4803_2010_01_01_posts.xls'};
postPaths(4) = {'SNA DATA\Original Data\2010-01-501\tkt4803_2010_01_501_posts.xls'};

posts = cell(numSections,1);
for i=1:numSections
    [~, pstStr] = xlsread([basePath char(postPaths(i))]);
    posts(i) = {pstStr};
end


%% Read the survey data
surveyPaths = cell(numSections, 1);
surveyPaths(1) = {'SNA DATA\Original Data\2009-01-01\2009_01_01_idiscuss_survey_multiple.xlsx'};
surveyPaths(2) = {'SNA DATA\Original Data\2009-01-501\tkt4803_2009_01_501_idiscuss_survey_multiple.xlsx'};
surveyPaths(3) = {'SNA DATA\Original Data\2010-01-01\tkt4803_2010_01_01_idiscuss_survey_multiple.xls'};
surveyPaths(4) = {'SNA DATA\Original Data\2010-01-501\tkt4803_2010_01_501_idiscuss_survey_multiple.xls'};

surveys = cell(numSections,1);
for i=1:numSections
    [~, srvyStr] = xlsread([basePath char(surveyPaths(i))]);
    surveys(i) = {srvyStr};
end


%% Read the topic view logs
tpcViewPaths = cell(numSections, 1);
tpcViewPaths(1) = {'SNA DATA\Original Data\2009-01-01\2009_01_01_idiscuss_topic_views.xlsx'};
tpcViewPaths(2) = {'SNA DATA\Original Data\2009-01-501\tkt4803_2009_01_501_idiscuss_topic_views.xlsx'};
tpcViewPaths(3) = {'SNA DATA\Original Data\2010-01-01\tkt4803_2010_01_01_idiscuss_topic_views.xls'};
tpcViewPaths(4) = {'SNA DATA\Original Data\2010-01-501\tkt4803_2010_01_501_idiscuss_topic_views.xls'};

tpcViews = cell(numSections,1);
for i=1:numSections
    [~, tpcVwStr] = xlsread([basePath char(tpcViewPaths(i))]);
    tpcViews(i) = {tpcVwStr};
end


%% Read the leaders' information
leadersPaths = cell(numSections, 1);
leadersPaths(1) = {'SNA DATA\Original Data\2009-01-01\2009_01_01_moderators.xlsx'};
leadersPaths(2) = {'SNA DATA\Original Data\2009-01-501\tkt4803_2009_01_501_moderators.xlsx'};
leadersPaths(3) = {'SNA DATA\Original Data\2010-01-01\tkt4803_2010_01_01_moderators.xlsx'};
leadersPaths(4) = {'SNA DATA\Original Data\2010-01-501\tkt4803_2010_01_501_moderators.xlsx'};

leaderList = cell(numSections,1);
leaderNums = cell(numSections,1);
for i=1:numSections
    [~, ~, leaderList{i}] = xlsread([basePath char(leadersPaths(i))]);
end


%% Read the graph data of each section
% Fixme: When some of these files are opened.
graphFiles = cell(numSections, 1);
graphPaths = cell(numSections, 1);
[graphFiles{1}, graphPaths{1}] = findFiles('C:\Temp\Leadership data\SNA DATA\Original Data\Reply-Post-2009-01-01');
[graphFiles{2}, graphPaths{2}] = findFiles('C:\Temp\Leadership data\SNA DATA\Original Data\Reply-Post-2009-01-501');
[graphFiles{3}, graphPaths{3}] = findFiles('C:\Temp\Leadership data\SNA DATA\Original Data\Reply-Post-2010-01-01');
[graphFiles{4}, graphPaths{4}] = findFiles('C:\Temp\Leadership data\SNA DATA\Original Data\Reply-Post-2010-01-501');

graphs = cell(numSections, 1);
for i=1:numSections
    secGraphs = cell(length(graphPaths{i})-1, 1);
    for j=1:(length(graphPaths{i})-1)
        [secGraphNum] = xlsread(char(graphPaths{i}(j)));
        secGraphNum(isnan(secGraphNum)) = 0;
        secGraphs{j} = secGraphNum;
    end
    graphs(i) = {secGraphs};
end


%% Read the raw version of the final data
finDataPaths = 'Final_Data-2012-03-11.xlsx';
[finNum, finStr] = xlsread([basePath finDataPaths]);
finNum(isnan(finNum)) = -1;

%% Read the normalized (0-1 scale) of the final data
finNormDataPaths = 'Leadership_Rescaled_Data-03-15-2011.xlsx';
[finNormNum, finNormStr] = xlsread([basePath finNormDataPaths]);
finNormNum(isnan(finNormNum)) = -1;

end