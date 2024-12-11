#include <cuda_runtime.h>
#include <iostream>

int main() {
    int deviceCount = 0;
    cudaGetDeviceCount(&deviceCount);  // ��ȡ�豸����

    if (deviceCount == 0) {
        std::cout << "û���ҵ�CUDA֧�ֵ��豸��" << std::endl;
        return 1;
    }

    for (int deviceId = 0; deviceId < deviceCount; deviceId++) {
        cudaDeviceProp deviceProp;
        cudaGetDeviceProperties(&deviceProp, deviceId);  // ��ȡ�豸����

        std::cout << "�豸 " << deviceId << "�� " << deviceProp.name << std::endl;

        // �鿴ÿ���豸��������Ԫ������CUDA����������
        std::cout << "ÿ��������Ԫ������߳���: " << deviceProp.maxThreadsPerBlock << std::endl;

        // �鿴ÿ���ദ������Streaming Multiprocessor��SM��������
        std::cout << "������Ԫ���� (Multiprocessor count): " << deviceProp.multiProcessorCount << std::endl;

        // ��������߳���
        int maxThreadsPerGrid = deviceProp.maxGridSize[0];  // �������ά��
        std::cout << "��������С: " << maxThreadsPerGrid << std::endl;
        std::cout << "ÿ���������߳���: " << deviceProp.maxThreadsPerBlock << std::endl;
        std::cout << "ÿ��������ά�ȣ�[" << deviceProp.maxThreadsDim[0] << ", "
            << deviceProp.maxThreadsDim[1] << ", " << deviceProp.maxThreadsDim[2] << "]" << std::endl;
    }

    return 0;
}
