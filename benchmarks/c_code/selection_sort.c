// #include <stdio.h>

void swap(int* arr, int idx_1, int idx_2) {
    int temp = arr[idx_1];
    arr[idx_1] = arr[idx_2];
    arr[idx_2] = temp;
}

void main() {
    int arr[50]; // starting at 0x00000
    // {50..1}
    for (int i = 0; i < 50; i++) {
        arr[i] = 50 - i;
    }
    
    for (int i = 0; i < 50; i++) {
        int smallest_index = i;
        for (int j = i; j < 50; j++) {
            // find smallest element of subarray
            if (arr[j] < arr[smallest_index]) {
                smallest_index = j;
            }
        }
        // swap current element with smallest
        swap(arr, i, smallest_index);
    }

    // printf("arr[");
    // for (int i = 0; i < 50; i++) {
    //     printf("%d, ", arr[i]);
    // }
    // printf("]");
}

