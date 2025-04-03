#include <iostream>

using namespace std;


int binary_search(int arr[], int l, int r, int x){
    if(l>r){
      return -1;
    }
    int mid = (l+r)/2;
    if(arr[mid] == x){
      return mid+1;
    }

    if(arr[mid] > x){
      return binary_search(arr, l, mid-1, x);
    }
    return binary_search(arr, mid+1, r, x);

}

int main() {
    int N;
    cin >> N;
    int arr[N];
    for(int i = 0; i < N; i++) {
      cin >> arr[i];
    }
    int M;
    cin >> M;
    while (M--) {
      int x;
      cin >> x;
      cout << binary_search(arr, 0, N-1, x) << endl;
    }

    return 0;
}
