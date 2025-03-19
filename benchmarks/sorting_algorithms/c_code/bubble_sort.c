#include <stdio.h>
#include <stdlib.h>

#define ARR_LENGTH 50

void swap(int* arr, int idx_1, int idx_2) {
    int temp = arr[idx_1];
    arr[idx_1] = arr[idx_2];
    arr[idx_2] = temp;
}

void print_arr(int* arr) {
    printf("arr[");
    for (int i = 0; i < ARR_LENGTH; i++) {
        printf("%d", arr[i]);
        if (i != 49) {
            printf(", ");
        }
    }
    printf("]\n");
}

void main() {
    int arr[ARR_LENGTH]; // starting at 0x00000
    for (int i = 0; i < ARR_LENGTH; i++) {
        arr[i] = rand();
    }
    print_arr(arr);

    for (int i = 0; i < (ARR_LENGTH - 1); i++) {
        for (int j = 0; j < (ARR_LENGTH - 1) - i; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr, j, j+1);
            }
        }
    }
    print_arr(arr);
}