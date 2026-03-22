#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cassert>
#include <queue>
#define int long long

using namespace std;

#pragma GCC optimize("O3,unroll-loops")

#define debug(x) cout << #x << " = " << (x) << "\n"
#define all(x) (x).begin(), (x).end()
#define pb push_back

typedef long long ll;
const int N = 2e5 + 12;
const ll inf = 1e18 + 7;

// toposort(false) -> without lex-order
int n;
void toposort(bool x) {
    if (x) {
        toposort();
    }
    else {
        for (int i = 1; i <= n; ++i)
            if (!visited[x]) {
                dfs(x);
            }
            reverse(all(res));
    }
}

vector<bool> visited;
vector<int> res;
vector<vector<int>> adj;
vector<int> deg;

void dfs(int u) {
    visited[u] = true;
    for (int x : adj[u]) {
        if (!visited[x]) {
            dfs(x);
        }
    }
    res.push_back(u);
}


void toposort() {
    priority_queue<int, vector<int>, greater<int>> pq; // minHeap
    for (int i = 1; i <= n; i++) {
        if (deg[i] == 0) {
            pq.push(i);
        }
    }

    while (!pq.empty()) {
        int u = pq.top(); pq.pop();
        res.push_back(u);
        for (int v : adj[u]) {
            deg[v]--;
            if (deg[v] == 0) {
                pq.push(v);
            }
        }
    }

}

void init_edges(int K) {
    while (K--) {
        int u, v; cin >> u >> v;
        adj[u].push_back(v);
        deg[v]++;
    }
}

void solve(){
    int m; bool tryb;
    cin >> n >> m >> tryb;
    visited.assign(n+1, 0);
    deg.assign(n+1, 0);
    adj.assign(n+1, vector<int>());
    res.clear();

    init_edges(m);
    toposort(tryb);


}

signed main(){
    ios_base::sync_with_stdio(false);
    cin.tie(0);

    int t = 1;
    // cin >> t;
    while(t--){
        solve();
    }
}
