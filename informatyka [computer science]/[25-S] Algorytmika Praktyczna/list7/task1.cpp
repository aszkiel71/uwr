#include <iostream>
using namespace std;
#pragma GCC optimize("Ofast")
#pragma GCC target("avx,bmi,bmi2,lzcnt,popcnt")
int find(int ST[], int v, int S, int node = 0) {
    if (node >= S) return node;
    if (ST[2 * node + 1] >= v) return find(ST, v, S, 2 * node + 1);
    else return find(ST, v, S, 2 * node + 2);
}

int main() {
    ios_base::sync_with_stdio(false); cin.tie(nullptr); cout.tie(nullptr);
    int N, Q; cin >> N >> Q;
    int S = 1; while (S < N) S *= 2; S--;
    int Hotel[4 * S + 4] = {0};
    for (int i = S; i < S + N; ++i) cin >> Hotel[i];
    for (int i = S - 1; i >= 0; --i) Hotel[i] = max(Hotel[2*i + 1], Hotel[2*i + 2]);
    while (Q--) {
        int q; cin >> q;
        if (q > Hotel[0]) {cout << 0 << ' ';    continue;
        }
        int idx = find(Hotel, q, S);
        cout << (idx - S + 1) << ' ';
        Hotel[idx] -= q;
        while (idx > 0) {
            idx = (idx - 1) / 2;
            Hotel[idx] = max(Hotel[2*idx + 1], Hotel[2*idx + 2]);
        }
    }
    return 0;
}