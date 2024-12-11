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
    // ����źų����Ƿ�Ϊ2���ݴη�
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

    int levels = log2(signalLength); // ������ȫ�ֽ�Ĳ���
    double* tempInput = input;
    double* tempOutput = output;

    for (int i = 0; i < levels; i++) {
        int currentLength = signalLength >> i; // ��ǰ���źŵĳ���
        haar1D_gpu(tempInput, tempOutput, currentLength);

        // ��������������루ֻ���ǰ�벿�ֽ���ϵ����
        tempInput = tempOutput; // ����Ϊ��һ�������
    }
}
