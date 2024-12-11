#include <cuda_runtime.h>
#include <iostream>
#include <cmath>
#include <fstream>
#include "wavelet.cuh"

__constant__ double sqrt_2 = 1.414213562373095;

__global__ void haar1Dkernel(double* input, double* output, int signalLength)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;

    if (idx >= signalLength / 2) return;


    output[idx] = (input[2 * idx] + input[2 * idx + 1]) / sqrt_2; // Approximation
    output[idx + signalLength / 2] = (input[2 * idx] - input[2 * idx + 1]) / sqrt_2; // Detail
}

void haar1D_gpu(double* input, double* output, int signalLength) {
    // 检查信号长度是否为2的幂次方
    if ((signalLength & (signalLength - 1)) != 0) {
        std::cerr << "Signal length must be a power of 2." << std::endl;
        return;
    }


    double* d_input;
    double* d_output;

    cudaMalloc(&d_input, signalLength * sizeof(double));
    cudaMalloc(&d_output, signalLength * sizeof(double));

    cudaMemcpy(d_input, input, signalLength * sizeof(double), cudaMemcpyHostToDevice);

    int threadsPerBlock = 256;
    int blocksPerGrid = (signalLength / 2 + threadsPerBlock - 1) / threadsPerBlock;

    haar1Dkernel <<< blocksPerGrid, threadsPerBlock >>> (d_input, d_output, signalLength);
    cudaGetLastError();
    cudaDeviceSynchronize();

    cudaMemcpy(output, d_output, signalLength * sizeof(double), cudaMemcpyDeviceToHost);

    cudaFree(d_input);
    cudaFree(d_output);
}

void fullDecomposition(double* input, double* output, int signalLength) {

    int levels = log2(signalLength); // 计算完全分解的层数
    double* tempInput = input;
    double* tempOutput = output;

    for (int i = 0; i < levels; i++) {
        int currentLength = signalLength >> i; // 当前层信号的长度
        haar1D_gpu(tempInput, tempOutput, currentLength);

        // 将结果拷贝回输入（只针对前半部分近似系数）
        tempInput = tempOutput; // 更新为下一层的输入
    }
}
