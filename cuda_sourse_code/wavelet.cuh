#ifndef WAVELET_HAAR_CUH
#define WAVELET_HAAR_CUH

__global__ void haar1Dkernel(double* input, double* output, int signalLength);
void haar1D_gpu(double* input, double* output, int signalLength);
void fullDecomposition(double* input, double* output, int signalLength);

#endif // !WAVELET_HAAR_CUH
