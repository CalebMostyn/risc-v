#define ARR_LENGTH 50
int arr[ARR_LENGTH];

void merge(int* arr, int left, int mid, int right) {
    int i = left, j = mid + 1;

    while (i <= mid && j <= right) {
        if (arr[i] <= arr[j]) {
            i++; // Element already in place
        } else {
            int value = arr[j];
            int index = j;

            // Shift all elements from i to j-1 right by one position
            while (index > i) {
                arr[index] = arr[index - 1];
                index--;
            }
            arr[i] = value;

            // Update indices
            i++;
            mid++;
            j++;
        }
    }
}

void merge_sort(int* arr, int left, int right) {
    if (left < right) {
        int mid = left + (right - left) / 2;

        // Recursively sort first and second halves
        merge_sort(arr, left, mid);
        merge_sort(arr, mid + 1, right);

        // Merge the sorted halves in place
        merge(arr, left, mid, right);
    }
}

int main() {
    merge_sort(arr, 0, ARR_LENGTH - 1);
}