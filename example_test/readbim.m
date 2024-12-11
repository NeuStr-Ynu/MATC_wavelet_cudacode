% 定义文件名
filename = 'data.bin';

% 打开文件
fileID = fopen(filename, 'r');

% 检查文件是否成功打开
if fileID == -1
    error('无法打开文件: %s', filename);
end

% 获取文件大小（以字节为单位）
fileSize = fseek(fileID, 0, 'eof');
fseek(fileID, 0, 'bof'); % 回到文件开头

% 计算文件中有多少个 double 数据
numDoubles = fileSize / 8; % 每个 double 占 8 字节

% 预分配数组以存储数据
data = zeros(1, numDoubles);

% 读取数据
data = fread(fileID, 'double');

% 关闭文件
fclose(fileID);

% 输出数据
disp('读取的数据为：');
disp(data);
