function [idcs] = getIndcsPerCH(posts, tsRow, numSections, chapterTSs)

% Organize the raw data indices by chater of each section

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
