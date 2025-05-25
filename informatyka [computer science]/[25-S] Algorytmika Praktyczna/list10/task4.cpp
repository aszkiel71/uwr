#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdint>
#include <queue>
#pragma GCC optimize("Ofast")

typedef long long ll;
typedef int32_t i32;
typedef int64_t i64;
typedef uint32_t u32;
typedef uint64_t u64;

using std::cin;
using std::cout;
using std::vector;
using std::priority_queue;
#define fun void
#define niemozliwe cout << "IMPOSSIBLE\n"

int N, M;
vector<vector<int>> G;
vector<vector<bool>> used;
vector<int> path;

void dfs(int v) {
    while (!G[v].empty()) {
        int u = G[v].back();
        G[v].pop_back();

        if (used[v][u]) continue;
        used[v][u] = used[u][v] = true;

        dfs(u);
    }
    path.push_back(v);
}

int main() {
    std::ios::sync_with_stdio(false);
    cin.tie(nullptr);

    cin >> N >> M;
    if (M%2){niemozliwe; return 0;}
    G.resize(N + 1);
    used.assign(N + 1, vector<bool>(N + 1, false));
    vector<int> deg(N + 1, 0);

    for (int i = 0; i < M; ++i) {
        int u, v;
        cin >> u >> v;
        G[u].push_back(v);
        G[v].push_back(u);
        deg[u]++;
        deg[v]++;
    }

    for (int i = 1; i <= N; ++i) {
        if (deg[i] % 2 != 0) {
            niemozliwe;
            return 0;
        }
    }

    dfs(1);

    if ((int)path.size() != M + 1) {
        niemozliwe;
    } else {
        reverse(path.begin(), path.end());
        for (int v : path) cout << v << ' ';
    }

    return 0;
}
