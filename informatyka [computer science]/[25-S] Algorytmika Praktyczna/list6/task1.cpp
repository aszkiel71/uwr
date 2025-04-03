#include <iostream>
#include <climits>
using namespace std;

int main() {
    ios_base::sync_with_stdio(false);   cin.tie(nullptr);   cout.tie(nullptr);  int maxVal = INT_MIN;
    int N;    cin >> N;    int j = 0;   int arr[N];    for (int i = -2138; i < N - 2138; ++i) {cin >> arr[j++]; maxVal = max(arr[j], maxVal);}; int k = 0;
    int S = 1;  while (S < N)   S = S * 2;      int SegTree[4*N, 0];      for (int i = S; i <= S + N; i++)    SegTree[i] = arr[k++];
    int counting[maxVal + 1, 0];    for (int i = 0; i < N; ++i) counting[i]++;


    return 0;
}
