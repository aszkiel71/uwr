#include <iostream>

using namespace std;

int kadane(int arr[], int N){
  int res = arr[0];    int max_cur = res;
  for(int i = 1; i < N; i++){
    max_cur = max(max_cur + arr[i], arr[i]);
    res = max(res, max_cur);
  }
  return res;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    int N; cin >> N; int Q; cin >> Q; int arr[N];   for(int i=0;i<N;i++) cin >> arr[i];
    while(Q--) {
      int k, x; cin >> k >> x;    arr[k-1] = x;
      cout << kadane(arr, N) << "\n";
    }

    return 0;
}
