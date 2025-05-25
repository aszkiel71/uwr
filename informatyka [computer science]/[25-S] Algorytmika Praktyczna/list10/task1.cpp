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

signed main() {
    std::ios_base::sync_with_stdio(false);cin.tie(nullptr);cout.tie(nullptr);
    int N, M; cin >> N >> M;
    vector<vector<int>> adj(N + 1);
    vector<int> in_deg(N + 1, 0);
    for (int i = 0; i < M; i++) {
        int u, v;
        cin >> u >> v;
        adj[u].push_back(v);
        in_deg[v]++;
    }

    priority_queue<int, vector<int>, std::greater<>> q;
    for (int i = 1; i <= N; i++) if (in_deg[i] == 0) q.push(i);

    vector<int> res;
    while (!q.empty()) {
        int u = q.top(); q.pop();
        res.push_back(u);
        for (int v : adj[u]) {
            if (--in_deg[v] == 0) q.push(v);
        }
    }

    if ((int)res.size() != N) {
        niemozliwe;
        return 0;
    }

    for (int x : res) cout << x << ' ';

    return 0;
}
