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

    for (int i = 0; i < (ARR_LENGTH - 1); i++) {
        for (int j = 0; j < (ARR_LENGTH - 1) - i; j++) {
            if (arr[j] > arr[j+1]) {
                swap(arr, j, j+1);
            }
        }
    }
}