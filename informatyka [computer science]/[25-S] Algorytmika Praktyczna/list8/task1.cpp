#include <iostream>
#include <vector>
using namespace std;
#pragma GCC optimize("Ofast")


int main() {
    ios::sync_with_stdio(false);    cout.tie(nullptr);      cin.tie(nullptr);
    int N, Q;   cin >> N >> Q;
    vector<int> parent(N+1);      parent[1] = 0;
    for (int i = 2; i <= N; i++) cin >> parent[i];

    int log = 0;
    int power = 1;
    while (power <= N) {
        log++;
        power *= 2;
    }
    vector<vector<int>> lift(log, vector<int>(N + 1));
    for (int v = 1; v <= N; v++)    lift[0][v] = parent[v];


    for (int j = 1; j < log; j++) {
        for (int v = 1; v <= N; v++) {
            int tmp = lift[j - 1][v];
            if (tmp != 0) {
                lift[j][v] = lift[j - 1][tmp];
            } else {
                lift[j][v] = 0; //no anc
            }
        }
    }

    while (Q--) {
        int v, k;   cin >> v >> k;
        int j = 0;      int pow2 = 1;
        while (j < log && v != 0) {
            if ((k / pow2) % 2 == 1) {
                v = lift[j][v];
            }
            j++;
            pow2 *= 2;
        }
        if (v == 0) {cout << -1 << '\n'; continue;}
        cout << v << '\n';
    }

    return 0;
}
