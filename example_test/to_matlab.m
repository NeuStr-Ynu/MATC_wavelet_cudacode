function dataArray=to_matlab()
    filename = 'outdata.bin';
    
    fileInfo = dir(filename);
    dataSize = fileInfo.bytes / 4; % 假设数据是单精度浮点数 (float)，每个元素占4字节
    
    % 创建内存映射文件
    m = memmapfile(filename, ...
        'Format', 'double', ... 
        'Writable', false);     % 只读
    
    % 读取数据
    data = m.Data;
    
    % 转换为 MATLAB 数组
    dataArray = reshape(data, [], 1); % 将数据转换为列向量
end

