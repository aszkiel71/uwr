#include <iostream>
#include <cstdint>
#include <vector>
#include <algorithm>
#pragma GCC optimize("Ofast")

typedef long long ll;
typedef int32_t i32;
typedef int64_t i64;
typedef uint32_t u32;
typedef uint64_t u64;

using std::cin;
using std::cout;
using std::vector;
#define fun void
#define niemozliwe cout << "IMPOSSIBLE\n"

fun dfs(int u, const vector<vector<int>>& adj, vector<int>& state, vector<int>& order, bool& has_cycle) {
    state[u] = 1;
    for (int v : adj[u]) {
        if (state[v] == 0) {
            dfs(v, adj, state, order, has_cycle);
            if (has_cycle) return;
        } else if (state[v] == 1) {
            has_cycle = true;
            return;
        }
    }
    state[u] = 2;
    order.push_back(u);
}

signed main() {
    std::ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, M; cin >> N >> M;
    vector<vector<int>> adj(N + 1);
    for (int i = 0; i < M; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
    }

    for (int i = 1; i <= N; ++i) {
        std::sort(adj[i].begin(), adj[i].end());
    }

    vector<int> state(N + 1, 0); // 0: unvisited, 1: visiting, 2: visited
    vector<int> order;
    bool has_cycle = false;

    for (int i = 1; i <= N; ++i) {
        if (state[i] == 0) {
            dfs(i, adj, state, order, has_cycle);
            if (has_cycle) {
                niemozliwe;
                return 0;
            }
        }
    }
    std::reverse(order.begin(), order.end());
    for (int v : order) {
        cout << v << ' ';
    }
    cout << '\n';

    return 0;
}
