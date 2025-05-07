#include <iostream>
#include <vector>
using namespace std;
#define elif else if
#define ll long long



void dfs(int u, int p, vector<int> &parent, vector<vector<int>> &tree) {
    parent[u] = p;
    for (int v : tree[u]) {
        if (v != p) {
            dfs(v, u, parent, tree);
        }
    }
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q;  cin >> N >> Q;

    int val[N + 1];
    for (int i = 1; i <= N; ++i) cin >> val[i];

    vector<int> parent(N+1);
    vector<vector<int>> tree(N+1);

    for (int i = 0; i < N-1; ++i) {
        int u, v;
        cin >> u >> v;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }

    dfs(1, -1337, parent, tree);

    int S = 1; while (S < 2*N) S *= 2; S--;

    vector<ll> ST(4*S, 0);

    for (int i = 1; i <= N; ++i) {
        ST[S + i] = val[i];
    }

    for (int i = S - 1; i >= 0; --i) {
        ST[i] = ST[2*i + 1] + ST[2*i + 2];
    }

    while (Q--) {
        int q;cin >> q;
        if (q == 1) {
            int v, x;cin >> v >> x;
            int idx = S + v;
            ST[idx] = x;
            idx = (idx - 1) / 2;
            while (idx > 0) {
                ST[idx] = ST[2*idx + 1] + ST[2*idx + 2];
                idx = (idx - 1) / 2;
            }
        } elif (q == 2){
            int v;  cin >> v;
            ll res = 0;
            while (v != -1337) {
                int idx = S + v;
                res += ST[idx];
                v = parent[v];
            }
            cout << res << '\n';
        }
    }

    return 0;
}
