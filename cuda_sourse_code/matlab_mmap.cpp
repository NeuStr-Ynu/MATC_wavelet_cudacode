#include <Windows.h>
#include <iostream>
#include <fstream>
#include "MATC_linker.h"


const char* INPUT_FILENAME = "data.bin";

// ӳ���ļ����ڴ�
void* MapFileToMemory() {
    HANDLE hfile;
    HANDLE h_mmap;

    int filesize=GetInputFileSize(INPUT_FILENAME);
    if (filesize == 0) {
        std::cout << "[error]:  File size is 0 or file does not exist." << std::endl;
        return nullptr;
    }

    hfile = CreateFile(
        INPUT_FILENAME,
        GENERIC_READ | GENERIC_WRITE,
        FILE_SHARE_READ | FILE_SHARE_WRITE,
        NULL,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        NULL
    );
    if (hfile == INVALID_HANDLE_VALUE) {
        std::cout << "[error]:  Failed to open file." << std::endl;
        return nullptr;
    }

    // ����ӳ�����
    h_mmap= CreateFileMapping(hfile, NULL, PAGE_READWRITE, 0, 0, NULL);
    if (h_mmap == INVALID_HANDLE_VALUE) {
        std::cout << "[error]:  Failed to create file mapping object." << std::endl;
        CloseHandle(hfile);
        return nullptr;
    }

    // ӳ�䵽�ڴ�
    void* haddress= MapViewOfFile(h_mmap, FILE_MAP_ALL_ACCESS, 0, 0, filesize);
    if (!haddress) {
        std::cout << "[error]:  Failed to create file mapping address." << std::endl;
        CloseHandle(hfile);
        CloseHandle(h_mmap);
        return nullptr;
    }

    // returnָ��
    CloseHandle(hfile);
    CloseHandle(h_mmap);
    return haddress;
}

// ��ȡ�ļ���С
int GetInputFileSize(const char* filepath) {
    std::ifstream file(filepath, std::ios::binary | std::ios::ate);
    if (!file.is_open()) {
        return 0;
    }
    return file.tellg();
}
