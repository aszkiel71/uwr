#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>
#define makeitfaster1 ios_base::sync_with_stdio(false)
#define makeitfaster2 cout.tie(nullptr)
#define makeitfaster3 cin.tie(nullptr)
#define duzo LLONG_MAX/5
#pragma GCC optimize("Ofast")

using namespace std;

struct Edge {
    int from, to;
    long long weight;
};

signed main() {
    makeitfaster1; makeitfaster2; makeitfaster3;

    int N, M;    cin >> N >> M;
    vector<Edge> edges(M);
    vector<long long> dist(N + 1, 0);
    vector<int> parent(N + 1, -1);

    for (int i = 0; i < M; ++i) {
        int u, v;
        long long w;
        cin >> u >> v >> w;
        edges[i] = {u, v, w};
    }

    int changedVertex = -1;

    for (int i = 1; i <= N; ++i) {
        changedVertex = -1;
        for (auto &e : edges) {
            if (dist[e.from] + e.weight < dist[e.to]) {
                dist[e.to] = dist[e.from] + e.weight;
                parent[e.to] = e.from;
                changedVertex = e.to;
            }
        }
    }

    if (changedVertex == -1) {
        cout << "NO\n";
    } else {
        cout << "YES\n";
        int x = changedVertex;
        for (int i = 0; i < N; ++i) {
            x = parent[x];
        }

        vector<int> cycle;
        int start = x;
        do {
            cycle.push_back(x);
            x = parent[x];
        } while (x != start || cycle.size() == 1);
        cycle.push_back(start);
        reverse(cycle.begin(), cycle.end());

        for (int v : cycle) cout << v << ' ';
        cout << '\n';
    }

    return 0;
}
