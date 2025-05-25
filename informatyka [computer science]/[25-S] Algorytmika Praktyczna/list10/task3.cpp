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
vector<ll> monety;
vector<ll> scc_sum;
vector<vector<int>> Gnew;
int scc = 0;

ll max(ll a, ll b){
    return (a > b) ? a : b;
}

fun dfs1(int v) {
    vis[v] = true;
    for (int u : G[v]) if (!vis[u]) dfs1(u);
    post.push_back(v);
}

fun dfs2(int v) {
    vis[v] = true;
    compscc[v] = scc;
    scc_sum[scc] += monety[v];
    for (int u : Grev[v]) if (!vis[u]) dfs2(u);
}


vector<bool> visTop;
vector<int> topoOrder;
fun dfsTopo(int v) {
    visTop[v] = true;
    for (int u : Gnew[v]) {
        if (!visTop[u]) dfsTopo(u);
    }
    topoOrder.push_back(v);
}

signed main() {
    std::ios_base::sync_with_stdio(false); cin.tie(nullptr); cout.tie(nullptr);

    cin >> N >> M;
    G.resize(N + 1);
    Grev.resize(N + 1);
    monety.resize(N + 1);

    for (int i = 1; i <= N; ++i) cin >> monety[i];

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
    scc_sum.resize(N + 1);

    for (int i = N - 1; i >= 0; --i) {
        int v = post[i];
        if (!vis[v]) {
            ++scc;
            dfs2(v);
        }
    }

    Gnew.resize(scc + 1);
    for (int u = 1; u <= N; ++u) {
        for (int v : G[u]) {
            int cu = compscc[u];
            int cv = compscc[v];
            if (cu != cv) {
                Gnew[cu].push_back(cv);
            }
        }
    }


    visTop.assign(scc + 1, false);

    for (int i = 1; i <= scc; ++i) {
        if (!visTop[i]) dfsTopo(i);
    }

    std::reverse(topoOrder.begin(), topoOrder.end());

    vector<ll> dp(scc + 1, 0);
    for (int i = 1; i <= scc; ++i) dp[i] = scc_sum[i];

    for (int u : topoOrder) {
        for (int v : Gnew[u]) {
            dp[v] = max(dp[v], dp[u] + scc_sum[v]);
        }
    }

    ll res = 0;
    for (int i = 1; i <= scc; ++i) {
        res = max(res, dp[i]);
    }

    cout << res << '\n';

    return 0;
}
