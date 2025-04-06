#include <iostream>
#include <vector>
#define ll long long
using namespace std;


int sqrt_r(int n) {
    int i = 1;
    while (i * i < n) {
        if (i * i == n)
            return i;
        i++;
    }
    return i;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N;
    cin >> N;
    vector<ll> arr(N + 1);
    for (int i = 1; i <= N; ++i)    cin >> arr[i];


    const int sqrtN = sqrt_r(N);
    vector<vector<ll>> pre_sum(sqrtN + 1);

    for (int b = 1; b <= sqrtN; b++) {
        pre_sum[b].resize(N + 1, 0);
        for (int i = N; i >= 1; i--) {
            pre_sum[b][i] = arr[i];
            if (i + b <= N)
                pre_sum[b][i] += pre_sum[b][i + b];
        }
    }

    int Q;
    cin >> Q;
    while (Q--) {
        int a, b;
        cin >> a >> b;
        if (b <= sqrtN) {
            cout << pre_sum[b][a] << "\n";
        } else {
            ll sum = 0;
            for (int i = a; i <= N; i += b) sum += arr[i];
            cout << sum << "\n";
        }
    }

    return 0;
}