function [data] = getDataByCH(posts, tgtCol, numSections, idcs)

% Organize the targeted data by chapter of each section

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
