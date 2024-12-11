function [outdata] = wavelet_gpu(data,type)
%WAVELET_GPU 用cuda的程序进行计算
%   [输出数据] = wavelet_gpu(输入数据,小波类型)
    to_bin(data);
    
    switch type
        case "haar"
            [status, cmdout] = system('haar1D_gpu.exe');
        otherwise
            error('type err')
    end
    disp(cmdout); % 显示控制台输出
    
    outdata=to_matlab();
end

