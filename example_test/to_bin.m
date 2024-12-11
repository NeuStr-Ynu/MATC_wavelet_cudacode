function [] = to_bin(data)
%TRANFORM_TO_BIN 把数据写入data.bin
%   [] = tranform_to_bin(data(列向量))

fileID = fopen('data.bin', 'wb');
if fileID == -1
    error('Failed to open file for writing.');
end
fwrite(fileID, data, 'double');  % 按列优先顺序写入数据
fclose(fileID);

end

