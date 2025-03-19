int arr[50];
int fibonacci(int n) {
    if (n <= 1) {
        return n;
    }
    return fibonacci(n - 1) + fibonacci(n - 2);
}	
int main() {
    for (int i = 0; i < 50; i++) {
        arr[i] = fibonacci(i);
    }
}