#include <iostream>
#include <vector>
#include <algorithm>
#include <climits>
#define makeitfaster1 ios_base::sync_with_stdio(false)
#define makeitfaster2     cout.tie(nullptr)
#define makeitfaster3     cin.tie(nullptr)
#define duzo LLONG_MAX/5
#pragma GCC optimize("Ofast")

using namespace std;




signed main() {
    makeitfaster1; makeitfaster2; makeitfaster3;
    int N, M, Q;  cin >> N >> M >> Q;
    long long dist[N+1][N+1];
    for (int i = 1; i <= N; ++i)
        for (int j = 1; j <= N; ++j)
            dist[i][j] = (i == j ? 0 : duzo);

    for (int i = 0; i < M; ++i) {
        int u, v;
        long long w;
        cin >> u >> v >> w;
        dist[u][v] = min(dist[u][v], w);
        dist[v][u] = min(dist[v][u], w);
    }

    for (int R = 0; R < 6; ++R) {
        for (int j = 1; j <= N; ++j) {
            for (int i = 1; i <= N; ++i) {
                for (int k = 1; k <= N; ++k) {
                    if (dist[i][j] > dist[i][k] + dist[k][j]) {
                        dist[i][j] = dist[i][k] + dist[k][j];
                    }
                }
            }
        }
    }


    for (int i = 0; i < Q; ++i) {
        int u, v; cin >> u >> v;
        if (dist[u][v] == duzo)
            cout << -1 << '\n';
        else
            cout << dist[u][v] << '\n';
    }

    return 0;
}
