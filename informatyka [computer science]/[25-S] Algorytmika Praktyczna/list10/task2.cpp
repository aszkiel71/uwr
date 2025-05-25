#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdint>
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

int N, M;
vector<vector<int>> G, Grev;
vector<bool> vis;
vector<int> post, compscc;
int scc = 0;

fun dfs1(int v) {
    vis[v] = true;
    std::sort(G[v].begin(), G[v].end());
    for (int u : G[v]) if (!vis[u]) dfs1(u);
    post.push_back(v);
}

fun dfs2(int v) {
    vis[v] = true;
    compscc[v] = scc;
    std::sort(Grev[v].begin(), Grev[v].end());
    for (int u : Grev[v]) if (!vis[u]) dfs2(u);
}

signed main() {
    std::ios_base::sync_with_stdio(false); cin.tie(nullptr); cout.tie(nullptr);

    cin >> N >> M;
    G.resize(N + 1);
    Grev.resize(N + 1);
    for (int i = 0; i < M; ++i) {
        int u, v; cin >> u >> v;
        G[u].push_back(v);
        Grev[v].push_back(u);
    }

    vis.assign(N + 1, false);
    for (int i = 1; i <= N; ++i)
        if (!vis[i]) dfs1(i);

    vis.assign(N + 1, false);
    compscc.resize(N + 1);

    for (int i = (int)post.size() - 1; i >= 0; --i) {
        int v = post[i];
        if (!vis[v]) {
            ++scc;
            dfs2(v);
        }
    }

    vector<int> compMin(scc + 1, N + 1);
    for (int v = 1; v <= N; ++v) {
        int c = compscc[v];
        if (v < compMin[c]) compMin[c] = v;
    }

    vector<std::pair<int,int>> order;
    for (int c = 1; c <= scc; ++c) {
        order.emplace_back(compMin[c], c);
    }
    std::sort(order.begin(), order.end());

    vector<int> newComp(scc + 1);
    for (int i = 0; i < scc; ++i) {
        newComp[order[i].second] = i + 1;
    }

    for (int v = 1; v <= N; ++v) {
        compscc[v] = newComp[compscc[v]];
    }

    cout << scc << '\n';
    for (int i = 1; i <= N; ++i) cout << compscc[i] << ' ';

    return 0;
}
