function [indvData] = separateIndvData(data, idColNum)

% Check how many depth the current data set is nested with
depth = checkDepth(data);

if depth == 1
    
elseif depth == 2
    numDataDepth1 = size(data,1);
    indvData = cell(numDataDepth1, 1);
    
    for i=1:numDataDepth1
        
        % Generate an ID list to be used to extract the data related to each ID
        curIDList = unique(data{i}(2:end, idColNum));        
        
    end
end

indvData = 0;

end