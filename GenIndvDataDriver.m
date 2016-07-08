function GenIndvDataDriver

% separateDataIndividual: Separate all the saved data of the given online 
% classes per individual

basePath = 'C:\Temp\Leadership data\';       % Base directory path


%% Read all the saved data
if ~exist([basePath 'input.mat'], 'file')
    [chatStrs, pstRtngs, posts, surveys, tpcViews, finNum, finStr, ...
        finNormNum, finNormStr, leaderList, graphs] = dataLoader(basePath);
    save([basePath 'input.mat']);
else
    load([basePath 'input.mat']);
end


%% Generate a lookup table
idxCell = struct('names', strtrim({finStr(2:end,5)}), ...
                'classIDs', {finNum(:,4)}, 'graphIDs', {finNum(:,1)}, ...
                'sections', {finNum(:,2)});
unqSec = unique(idxCell.sections, 'stable');
for i=1:length(unqSec)
    curSecIdcs = find(idxCell.sections == unqSec(i));
    idxCell.sections(curSecIdcs) = i;
end

[nameUidGidSidTbl] = genLookUpTable(idxCell);


%% Separate the data per individual
indvPostsDir = [basePath 'SNA DATA\post_indv'];
indvSentDir = [basePath 'SNA DATA\sent_graph_indv'];
indvRcvdDir = [basePath 'SNA DATA\rcvd_graph_indv'];
ensureDirExists(indvPostsDir, 1);
ensureDirExists(indvSentDir, 1);
ensureDirExists(indvRcvdDir, 1);

rcvdGraphs = genReceivedGraph(graphs);

indvPosts = separateIndvData(posts, 4);
indvSents = separateIndvData(graphs, 1);
indvRcvds = separateIndvData(rcvdGraphs, 1);

end