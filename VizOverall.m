function [histInfoSt] = VizOverall(tsData, numFiles)

% Represent an overall histogram for all the four dicussion data based on
% the timeline

global basePath;

numBins = cell(numFiles,1);     % Number of total bins
binEdges = cell(numFiles,1);    % Left and right border of each bin
values = cell(numFiles,1);      % Value in each bin
midBins = cell(numFiles,1);     % Mid point of each bin
for i=1:length(numBins)
    erlstTS = min(tsData{i});
    ltstTS = max(tsData{i});
    numBins(i) = {floor(ltstTS - erlstTS + 1)};
    h = histogram(tsData{i}, cell2mat(numBins(i)));
    
    binEdges(i) = {h.BinEdges'};
    values(i) = {h.Values'};
    midBin = zeros(length(binEdges{i})-1, 1);
    for j=2:length(binEdges{i})
        midBin(j-1) = (binEdges{i}(j-1) + binEdges{i}(j)) / 2;
    end
    midBins(i) = {midBin};
    
    if i == 1
        hold on;
    end
end
title('Histograms (Number of postings)');
xlabel('Time');
ylabel('Num Postings');
legend('2009\_01\_01', '2009\_01\_501', '2010\_01\_01', '2010\_01\_501');
hold off;

histInfoSt = struct('numBins', numBins, 'binEdges', binEdges, ...
                    'values', values, 'midBins', midBins);

if ~exist([basePath 'Overall_Histo.png'], 'file')
    print([basePath 'Overall_Histo'], '-dpng');
end

end