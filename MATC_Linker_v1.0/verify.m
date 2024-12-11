inputSignal=[1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0, 11.0, 12.0, 13.0, 14.0, 15.0, 16.0];
cudaResult=[2.12132 4.94975 7.77817 10.6066 13.435 16.2635 19.0919 21.9203 -0.707107 -0.707107 -0.707107 -0.707107 -0.707107 -0.707107 -0.707107 -0.707107];
verifyHaar1DWithMATLABToolbox(cudaResult, inputSignal)

function verifyHaar1DWithMATLABToolbox(cudaResult, inputSignal)
    % VERIFYHAAR1DWITHMATLABTOOLBOX 验证 CUDA Haar 小波变换结果是否正确
    % 输入:
    %   cudaResult - 从 CUDA 输出的变换结果
    %   inputSignal - 输入的 1D 信号
    
    % 确保输入信号长度为 2 的整数幂
    n = length(inputSignal);
    if mod(log2(n), 1) ~= 0
        error('Input signal length must be a power of 2');
    end
    
    % 使用 MATLAB 的 Haar 小波变换
    wavelet = 'haar';
    [C, L] = wavedec(inputSignal, 1, wavelet); % 1 层小波分解
    approx = appcoef(C, L, wavelet);          % 近似系数
    detail = detcoef(C, L, 1);                % 细节系数
    
    % 拼接 MATLAB 结果
    matlabResult = [approx, detail];
    
    % 比较 CUDA 和 MATLAB 结果
    disp('Comparing MATLAB and CUDA results...');
    disp('MATLAB Result:');
    disp(matlabResult);
    disp('CUDA Result:');
    disp(cudaResult);
    
    % 计算误差
    error = norm(matlabResult - cudaResult, 2);
    if error < 1e-6
        disp('Haar transform verification passed!');
    else
        disp('Haar transform verification failed!');
        fprintf('Error: %f\n', error);
    end
end
