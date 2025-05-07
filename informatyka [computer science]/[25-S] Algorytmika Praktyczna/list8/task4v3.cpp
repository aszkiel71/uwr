#include <iostream>
#include <vector>
#include <climits>
#pragma GCC optimize("Ofast")
using namespace std;

struct our_pair { int id; int h; };

void dfs(int u, int p, vector<our_pair> &euler_tour, vector<vector<int>> &tree, vector<int> &depth) {
    euler_tour.push_back({u, depth[u]});
    for (int v : tree[u]) if (v != p) {
        depth[v] = depth[u] + 1;
        dfs(v, u, euler_tour, tree, depth);
        euler_tour.push_back({u, depth[u]});
    }
}

int main() {
    ios::sync_with_stdio(false);
    cin.tie(nullptr);

    int N, Q;
    cin >> N >> Q;
    vector<vector<int>> tree(N + 1);
    for (int i = 0; i < N - 1; i++) {
        int u, v;
        cin >> u >> v;
        tree[u].push_back(v);
        tree[v].push_back(u);
    }

    vector<our_pair> euler_tour;
    vector<int> depth(N + 1, 0);
    dfs(1, 0, euler_tour, tree, depth);

    vector<int> occurence(N + 1, -1);
    for (int i = 0; i < N; i++)
        if (occurence[euler_tour[i].id] == -1)
            occurence[euler_tour[i].id] = i;

    int S = 1;
    while (S <= N) S *= 2;  S--;

    vector<int> ST(4 * S, -1337);
    for (int i = 0; i < N; i++)
        ST[S + i] = i;

    for (int i = S - 1; i >= 0; --i) {
        if (ST[2*i + 1] == -1337) ST[i] = ST[2*i + 2];
        else if (ST[2*i + 2] == -1337) ST[i] = ST[2*i + 1];
        else ST[i] = (euler_tour[ST[2*i + 1]].h <= euler_tour[ST[2*i + 2]].h ? ST[2*i + 1] : ST[2*i + 2]);
    }

    while (Q--) {
        int u, v;
        cin >> u >> v;
        if (u == v) {
            cout << 0 << "\n";
            continue;
        }
        int l = occurence[u], r = occurence[v];
        if (l > r) swap(l, r);
        l += S; r += S;

        int best = -1;
        while (l <= r) {
            if (l % 2 == 1) {
                int cur = ST[l++];
                if (best == -1 || (cur != -1 && euler_tour[cur].h < euler_tour[best].h))
                    best = cur;
            }
            if (r % 2 == 0) {
                int cur = ST[r--];
                if (best == -1 || (cur != -1 && euler_tour[cur].h < euler_tour[best].h))
                    best = cur;
            }
            l = (l - 1) / 2;
            r = (r - 1) / 2;
        }

        int lca = euler_tour[best].id;
        cout << depth[u] + depth[v] - 2*depth[lca] << "\n";
    }

    return 0;
}
