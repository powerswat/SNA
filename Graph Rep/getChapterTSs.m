function [chapterTSs] = getChapterTSs(numSections, leaderList)

% Generate a list of starting/ending timestamps per chapter

chapterTSs = cell(numSections, 1);

for i=1:numSections
    numChapters = max(cell2mat(leaderList{i}(2:end, 2)));
    chapterTS = zeros(numChapters, 2);
    chapterTS(:,1) = sort(unique(datenum(leaderList{i}(2:end,3))));
    chapterTS(:,2) = sort(unique(datenum(leaderList{i}(2:end,4))));
    chapterTSs{i} = chapterTS;
end

end
