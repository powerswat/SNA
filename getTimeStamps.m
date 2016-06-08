function [TSs] = getTimeStamps(rawData, numCell, stRowNum, colNum)

TSs = cell(numCell, 1);
for i=1:numCell
    TSs(i) = {datenum(char(rawData{i}(stRowNum:end, colNum)))};
end

end