#include <iostream>
#include <fstream>
#include <cuda_runtime.h>
#include "MATC_linker.h"
#include "wavelet.cuh"

/*Written by Zipeng Wang @KunMing*/

int main() {
    int size_of = sizeof(double);

    void* voidptr_data = MapFileToMemory();  // Ensure this works
    if (voidptr_data == nullptr) {
        std::cout << "[error]: Data does not exist." << std::endl;
        return 1;
    }

    int dataLength = GetInputFileSize(INPUT_FILENAME) / size_of;

    double* data_ptr = (double*)malloc(dataLength * sizeof(double));
    if (data_ptr == NULL) {
        std::cout << "[error]: Memory allocation failed!\n" << std::endl;
        return 1;
    }
    double* result_ptr = (double*)malloc(dataLength * sizeof(double));
    std::memcpy(data_ptr, voidptr_data, dataLength * sizeof(double));

    std::cout << "First ten inpute data:" << std::endl;
    for (int i = 0; i < 10 && i < dataLength; ++i) {
        std::cout << data_ptr[i] << std::endl;
    }


    // 计算 haar1D_gpu
    haar1D_gpu(data_ptr, result_ptr, dataLength);

    // 确保CUDA完成后再继续
    cudaDeviceSynchronize();

    std::cout << "First ten transformed results:" << std::endl;
    for (int i = 0; i < 10 && i < dataLength; ++i) {
        std::cout << result_ptr[i] << std::endl;
    }

    // 输出数据
    FILE* file = fopen("outdata.bin", "wb");
    if (file == NULL) {
        std::cout << "[error]: outdata.bin Failed to open file\n" << std::endl;
        free(data_ptr);
        free(result_ptr);
        return 1;
    }

    if (fwrite(result_ptr, sizeof(double), dataLength, file) != dataLength) {
        perror("Failed to write data to file");
        fclose(file);
        free(data_ptr);
        free(result_ptr);
        return 1;
    }

    // 关闭文件
    fclose(file);

    // 释放内存
    free(data_ptr);
    free(result_ptr);

    return 0;
}
