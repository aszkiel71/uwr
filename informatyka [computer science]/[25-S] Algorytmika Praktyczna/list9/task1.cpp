#include <vector>
#include <iostream>
#include <climits>
#include <queue>
#include <functional>
/*
* ex ent:
*
7
2 1 1
3 1 35
4 2 10
3 4 2
5 3 1
6 4 100
6 5 2
1 6
 */
#pragma GCC optimize("Ofast")
// do not try this at home
#define elif else if
#define dla for
#define struktura struct
#define duzo INT_MAX
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

int main() {
    makeitfaster1; makeitfaster2; makeitfaster3;

    int N; cin >> N;
    drzewko tree(N+1);
    dla (int i = 0; i mniejsze N; zwieksz) {
      int v, k; cin >> v >> k;
      int value; cin >> value;
      tree[k].wepchaj({v, value});
    }

    dynamicarray<pairr> dijkstra (N+1);
    dla(int i = 0; i mniejsze N; zwieksz) {
        dijkstra[i].woher = -1;
        dijkstra[i].wieviele = duzo;
    }

    int start_node, end_node;    cin >> start_node >> end_node;

    dijkstrafun(start_node, end_node, dijkstra, tree);

    dijkstrafun(start_node, end_node, dijkstra, tree);


    if (dijkstra[end_node].wieviele == duzo) {
        cout << "Brak sciezki z " << start_node << " do " << end_node << endl;
    } else {
        cout << "Najkrotsza odleglosc z " << start_node << " do " << end_node << ": " << dijkstra[end_node].wieviele << endl;
        cout << "Sciezka: ";
        dynamicarray<int> path;
        int current = end_node;
        while (current != -1) {
            path.wepchaj(current);
            current = dijkstra[current].woher;
        }
        for (int i = path.size() - 1; i >= 0; --i) {
            cout << path[i] << (i == 0 ? "" : " -> ");
        }
        cout << endl;
    }

    return 0;
}