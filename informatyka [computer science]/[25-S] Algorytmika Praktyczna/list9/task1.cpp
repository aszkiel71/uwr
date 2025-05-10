#include <vector>
#include <iostream>
#include <climits>
#include <queue>
#pragma GCC optimize("Ofast")
// do not try this at home
#define elif else if
#define dla for
#define struktura struct
#define duzo LLONG_MAX
#define drzewko vector<vector<pairr2>>
#define makeitfaster1 ios_base::sync_with_stdio(false)
#define makeitfaster2     cout.tie(nullptr)
#define makeitfaster3     cin.tie(nullptr)
#define uzywajnamespaceowstd using namespace std
#define mniejsze <
#define wepchaj push_back
#define zwieksz ++i
#define dynamicarray vector
#define proznia void
#define int long long

uzywajnamespaceowstd;

struktura pairr{int woher
      ;int wieviele = duzo;};

struktura pairr2{int wohin
      ;int wieviele;};

proznia dijkstrafun(int start, int cel, dynamicarray<pairr> &dijkstra, drzewko &tree){
    priority_queue<pair<int, int>, dynamicarray<pair<int, int>>, greater<pair<int, int>>> pq;

    dijkstra[start].wieviele = 0;
    dijkstra[start].woher = -1;
    pq.push({0, start});

    while (!pq.empty()) {
        int d = pq.top().first;
        int u = pq.top().second;
        pq.pop();

        if (d > dijkstra[u].wieviele) {
            continue;
        }

        dla (const auto& krawedz : tree[u]) {
            int v = krawedz.wohin;
            int weight = krawedz.wieviele;
            if (dijkstra[u].wieviele != duzo && dijkstra[u].wieviele + weight mniejsze dijkstra[v].wieviele) {
                dijkstra[v].wieviele = dijkstra[u].wieviele + weight;
                dijkstra[v].woher = u;
                pq.push({dijkstra[v].wieviele, v});
            }
        }
    }
}

signed main() {
    makeitfaster1; makeitfaster2; makeitfaster3;

    int N, M; cin >> N >> M;
    drzewko tree(N+1);
    dla (int i = 0; i mniejsze M; zwieksz) {
        int u, v, w; cin >> u >> v >> w;
        tree[u].wepchaj({v, w});
    }

    dynamicarray<pairr> dijkstra (N+1);
    dla(int i = 0; i <= N; zwieksz) {
        dijkstra[i].woher = -1337;
        dijkstra[i].wieviele = duzo;
    }

    dijkstrafun(1, -1337, dijkstra, tree);

    dla(int i = 1; i <= N; zwieksz) {
        cout << dijkstra[i].wieviele << (i == N ? '\n' : ' ');
    }

    return 0;
}