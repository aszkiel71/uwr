#include <iostream>

using namespace std;

void quick_sort(int *arr, int left, int right) {
    if (left >= right)
        return;

    int i = left, j = right;
    int pivot = arr[(left + right) / 2];

    while (i <= j) {
        while (arr[i] < pivot) i++;
        while (arr[j] > pivot) j--;
        if (i <= j) {
            int temp = arr[i];
            arr[i] = arr[j];
            arr[j] = temp;
            i++;
            j--;
        }
    }

    if (left < j)
        quick_sort(arr, left, j);
    if (i < right)
        quick_sort(arr, i, right);
}

int main() {
    int *arr;
    int n;
    cin >> n;

    arr = new int[n];

    for (int i = 0; i < n; i++) {
        cin >> arr[i];
    }

    quick_sort(arr, 0, n - 1);

    for (int i = 0; i < n; i++) {
        cout << arr[i] << endl;
    }

    delete[] arr;

    return 0;
}
