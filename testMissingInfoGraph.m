function [mssngNode, vecType, loc] = testMissingInfoGraph(msgSentIdx, msgRcvdIdx)

% Test if there are any missing nodes in the graph and return the node
% numbers if there are
if length(msgSentIdx) < length(msgRcvdIdx)
    [mssngNode, loc] = setdiff(msgRcvdIdx, msgSentIdx);
    vecType = 0;
elseif length(msgSentIdx) > length(msgRcvdIdx)
    [mssngNode, loc] = setdiff(msgSentIdx, msgRcvdIdx);
    vecType = 1;
else
    mssngNode = -1;
    vecType = -1;
    loc = -1;
end

end