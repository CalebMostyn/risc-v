int arr[50];
int factorial(int n) {
    if (n <= 1) {
        return 1;
    }
    return n * factorial(n - 1);
}	
int main() {
    for (int i = 0; i < 50; i++) {
        arr[i] = factorial(i);
    }
}