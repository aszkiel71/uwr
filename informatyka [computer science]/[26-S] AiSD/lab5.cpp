#include <iostream>
#include <vector>
#include <string>
#include <algorithm>
#include <cassert>

using namespace std;

#pragma GCC optimize("O3,unroll-loops")

#define debug(x) cout << #x << " = " << (x) << "\n"
#define all(x) (x).begin(), (x).end()
#define pb push_back

typedef long long ll;
const int N = 2e5 + 12;
const ll inf = 1e18 + 7;

// https://github.com/aszkiel71/CP_Algorithms/blob/main/helpful/dsu.cpp

vector<int> leaders;
vector<int> sz;

void make_set(int x){
    leaders[x] = x;
    sz[x] = 1;
}

int find_set(int x){
    if(x == leaders[x]) return x;
    return (leaders[x] = find_set(leaders[x])); // Compression
}

void union_set(int u, int v){
    u = find_set(u); v = find_set(v);
    if(u == v) return;
    if(sz[u] < sz[v]) swap(u, v);
    sz[u] += sz[v];
    leaders[v] = leaders[u]; // Compression - Small to Large
}



void solve(){
    int n, m; cin >> n >> m;
    leaders.resize(n * m + 1);
    sz.resize(n * m + 1);
    vector<pair<int, int>> plansza;
    vector<bool> state(n * m + 1, false);

    for (int i = 0; i < n * m; i++) {
        int h; cin >> h;
        plansza.pb({h, i}); // note: 1d index. h <- wysokosc
        make_set(i);
    }

    sort(all(plansza)); reverse(all(plansza));

    int q; cin >> q;
    vector<int> t(q);
    for (int &qq : t) {
        cin >> qq; // lowk cool trick
    }

    int curr = 0;
    int idx = 0;

    for (int qq = q - 1; qq >= 0; qq--) {
        int lvl = t[qq];

        while (idx < n * m && plansza[idx].first > lvl) {
            int snd = plansza[idx].second;
            state[snd] = true;
            curr++;

            int r = snd / m; // row
            int c = snd % m; // col

            if (r > 0 && state[snd - m]) {
                int u = find_set(snd), v = find_set(snd - m);
                union_set(u, v);
                curr -= (u != v);
            }

            if (r < n - 1 && state[snd + m]) {
                int u = find_set(snd), v = find_set(snd + m);
                union_set(u, v);
                curr -= (u != v);
            }

            if (c > 0 && state[snd - 1]) {
                int u = find_set(snd), v = find_set(snd - 1);
                union_set(u, v);
                curr -= (u != v);
            }

            if (c < m - 1 && state[snd + 1]) {
                int u = find_set(snd), v = find_set(snd + 1);
                union_set(u, v);
                curr -= (u != v);
            }
            idx++;
        }
        t[qq] = curr;
    }
    for (int i = 0; i < q; i++) {
        cout << t[i] << " ";
    }
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
