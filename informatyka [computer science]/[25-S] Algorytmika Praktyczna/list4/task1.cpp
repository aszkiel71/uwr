#include <iostream>
#include <vector>
#include <cmath>
using namespace std;

int log2(int n)
{
    int result = 0;
    int tmp = 1;
    while (tmp < n)
    {
        tmp *= 2;
        result++;
    }
    return result;
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q;
    cin >> N >> Q;

    vector<int> arr(N);
    for (int i = 0; i < N; i++) {
        cin >> arr[i];
    }

    int maxPower = log2(N);
    vector<vector<int>> st(maxPower + 1, vector<int>(N));

    for (int i = 0; i < N; i++) {
        st[0][i] = arr[i];
    }

    for (int p = 1; p <= maxPower; p++) {
        int jump = pow(2, p-1);
        for (int i = 0; i + jump < N; i++) {
            st[p][i] = min(st[p-1][i], st[p-1][i + jump]);
        }
    }

    for (int i = 0; i < Q; i++) {
        int a, b;
        cin >> a >> b;
        a--; b--;


        if (a == b) {
            cout << arr[a] << "\n";
            continue;
        }

        int len = b - a + 1;
        int p = log2(len) - 1;
        int range = pow(2, p);

        int result = min(st[p][a], st[p][b - range + 1]);
        cout << result << "\n";
    }

    return 0;
}