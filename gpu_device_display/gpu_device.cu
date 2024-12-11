#include <cuda_runtime.h>
#include <iostream>

int main() {
    int deviceCount = 0;
    cudaGetDeviceCount(&deviceCount);  // 获取设备数量

    if (deviceCount == 0) {
        std::cout << "没有找到CUDA支持的设备！" << std::endl;
        return 1;
    }

    for (int deviceId = 0; deviceId < deviceCount; deviceId++) {
        cudaDeviceProp deviceProp;
        cudaGetDeviceProperties(&deviceProp, deviceId);  // 获取设备属性

        std::cout << "设备 " << deviceId << "： " << deviceProp.name << std::endl;

        // 查看每个设备的流处理单元数量（CUDA核心数量）
        std::cout << "每个流处理单元的最大线程数: " << deviceProp.maxThreadsPerBlock << std::endl;

        // 查看每个多处理器（Streaming Multiprocessor，SM）的数量
        std::cout << "流处理单元数量 (Multiprocessor count): " << deviceProp.multiProcessorCount << std::endl;

        // 计算最大线程数
        int maxThreadsPerGrid = deviceProp.maxGridSize[0];  // 最大网格维度
        std::cout << "最大网格大小: " << maxThreadsPerGrid << std::endl;
        std::cout << "每个块的最大线程数: " << deviceProp.maxThreadsPerBlock << std::endl;
        std::cout << "每个块的最大维度：[" << deviceProp.maxThreadsDim[0] << ", "
            << deviceProp.maxThreadsDim[1] << ", " << deviceProp.maxThreadsDim[2] << "]" << std::endl;
    }

    return 0;
}
