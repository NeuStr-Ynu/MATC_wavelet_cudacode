clear;clc;

% 生成时间向量和信号
t = linspace(0, 1, 2^9);  % 时间向量
signal1 = sin(2*pi*10*t); %+ 0.5*randn(size(t));  % 信号 1

% 计算 Haar 小波变换
n = length(signal1);
signal_haar = signal1;  % 初始信号

tic
% 进行 Haar 小波变换
% while mod(n, 2) == 0
    temp = zeros(1, n/2);
    for i = 1:n/2
        temp(i) = (signal_haar(2*i-1) + signal_haar(2*i)) / sqrt(2);  % 近似部分
        signal_haar(i) = (signal_haar(2*i-1) - signal_haar(2*i)) / sqrt(2);  % 细节部分
    end
    signal_haar(1:n/2) = temp;  % 更新信号
    n = n / 2;
% end
toc

% 绘制信号和 Haar 小波变换后的结果
figure;

subplot(3, 1, 1);
plot(t, signal1);
title('Original Signal');

subplot(3, 1, 2);
plot(t(1:length(signal_haar)), signal_haar);
title('Haar Transformed Signal (after first iteration)');

% 这里只展示了第一次变换后的近似与细节部分


%% 下面使用CUDA
tic
[outdata] = wavelet_gpu(signal1','haar');
toc
subplot(3, 1, 3);
plot(t(1:length(outdata)), outdata);
title('Haar Transformed Signal (after first iteration)');