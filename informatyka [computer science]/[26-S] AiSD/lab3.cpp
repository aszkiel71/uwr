#include <algorithm>
#include <cassert>
#include <iostream>
#include <string>
#include <vector>
// #define int long long

using namespace std;

#pragma GCC optimize("O3,unroll-loops")

#define debug(x) cout << #x << " = " << (x) << "\n"
#define all(x) (x).begin(), (x).end()
#define pb push_back

typedef long long ll;
const ll inf = 1e18 + 7;

class MinHeap {
 private:
  ll n;
  vector<pair<ll, int>> heap;

 public:
  MinHeap() : n(0) {}

  void insert(ll dist, int v) {
    heap.pb({dist, v});
    n++;
    move_up(n - 1);
  }

  pair<ll, int> pop() {
    auto res = heap[0];
    heap[0] = heap[n - 1];
    n--;
    heap.pop_back();
    if (n > 0) move_down(0);
    return res;
  }

  void move_up(ll i) {
    while (i > 0) {
      ll p = (i - 1) / 2;
      if (heap[p].first <= heap[i].first) break;
      swap(heap[p], heap[i]);
      i = p;
    }
  }

  void move_down(ll i) {
    while (true) {
      ll l = 2 * i + 1, r = 2 * i + 2;
      ll best = i;
      if (l < n && heap[l].first < heap[best].first) best = l;
      if (r < n && heap[r].first < heap[best].first) best = r;
      if (best == i) break;
      swap(heap[i], heap[best]);
      i = best;
    }
  }

  bool empty() { return n == 0; }

  ll get_min_dist() { return heap[0].first; }

  void print() {
    for (auto p : heap) {
      cout << p.first << "(" << p.second << ")";
    }
    cout << "\n";
  }
};

void solve() {
  ll n, m, k;
  cin >> n >> m >> k;
  vector<vector<pair<int, int>>> adj(n + 1);

  for (ll i = 0; i < m; i++) {
    ll u, v;
    int w;
    cin >> u >> v >> w;
    adj[u].pb({v, w});
    adj[v].pb({u, w});
  }

  MinHeap pq;
  vector<ll> dist(n + 1, inf);
  dist[1] = 0;
  pq.insert(0, 1);

  while (!pq.empty()) {
    auto [d, v] = pq.pop();
    if (d > dist[v]) continue;

    for (auto& e : adj[v]) {
      ll u = e.first, w = e.second;
      if (dist[u] > dist[v] + w) {
        dist[u] = dist[v] + w;
        pq.insert(dist[u], u);
      }
    }
  }

  ll res = 0;
  bool possible = true;

  for (ll i = 0; i < k; i++) {
    ll t;
    cin >> t;
    if (dist[t] >= inf) {
      possible = false;
    } else {
      res += 2 * dist[t];
    }
  }

  if (!possible) {
    cout << "NIE\n";
  } else {
    cout << res << "\n";
  }
}

signed main() {
  ios_base::sync_with_stdio(false);
  cin.tie(0);

  int t = 1;
  // cin >> t;
  while (t--) {
    solve();
  }
}
