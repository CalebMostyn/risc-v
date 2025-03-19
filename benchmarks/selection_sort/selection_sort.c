#define ARR_LENGTH 50
int arr[ARR_LENGTH];

void swap(int* arr, int idx_1, int idx_2) {
    int temp = arr[idx_1];
    arr[idx_1] = arr[idx_2];
    arr[idx_2] = temp;
}

void main() {
    // Leaving unitialized, python script initializes data memory to random values
    // in leu of syscalls
    
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
}

