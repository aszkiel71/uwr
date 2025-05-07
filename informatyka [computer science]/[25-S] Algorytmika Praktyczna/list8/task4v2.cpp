#include <iostream>
#include <vector>
// too slow
using namespace std;
void dfs(int u, int v, int p, int &res, const vector<vector<int>>& tree, int dis = 0) {
    if (u == v) {res = dis;return;}
    for (int ver : tree[u]) {
        if (ver != p) {
            dfs(ver, v, u,  res, tree, dis + 1);
            if (res != -1) {
                return;
            }
        }
    }
}

int main() {
    ios_base::sync_with_stdio(false);   cin.tie(nullptr);   cout.tie(nullptr);

    int N, Q;       cin >> N >> Q;
    vector<vector<int>> tree(N + 1);

    for (int i = 0; i < N - 1; ++i) {
        int u, v;   cin >> u >> v;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }

    while (Q--) {
        int u, v; cin >> u >> v;
        int res = -1;       dfs(u, v, -1,  res, tree);
        cout << res << "\n";
    }

    return 0;
}