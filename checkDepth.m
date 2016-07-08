function depth = checkDepth(data)

% Check how many depth the current data set is nested with
%   Assumption: All sub-data sets in the current layer has the same depth

depth = 0;
while(iscell(data))
    data = data{1};
    depth = depth + 1;
end

end