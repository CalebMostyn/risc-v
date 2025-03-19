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
    
    for (int i = 0; i < ARR_LENGTH; i++) {
        int smallest_index = i;
        for (int j = i; j < ARR_LENGTH; j++) {
            // find smallest element of subarray
            if (arr[j] < arr[smallest_index]) {
                smallest_index = j;
            }
        }
        // swap current element with smallest
        swap(arr, i, smallest_index);
    }
    print_arr(arr);
}

