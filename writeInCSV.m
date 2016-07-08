function writeInCSV(filePath, data, mode)

fid = fopen(filePath, 'w');
[rowSize, colSize] = size(data);
if strcmp(mode, 'lookup_table')
    for i=1:rowSize
        for j=1:colSize-1
            if j==1
                fprintf(fid, '%s,', data{i,j});
            else
                fprintf(fid, '%f,', data{i,j});
            end
        end
        fprintf(fid, '%f\r\n', data{i,j});
    end
elseif strcmp(mode, 'graph')
    csvwrite(filePath, data);
end
fclose(fid);

end