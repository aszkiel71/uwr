#pragma GCC optimize("O3,unroll-loops")

#include <algorithm>
#include <cassert>
#include <iostream>
#include <string>
#include <vector>
// #define int long long

using namespace std;

#define debug(x) cout << #x << " = " << (x) << "\n"
#define all(x) (x).begin(), (x).end()
#define pb push_back

typedef long long ll;
const int N = 1e6 + 12;
const ll inf = 1e18 + 7;

int dp[N], saver[N];

void solve() {
  int n;
  cin >> n;
  vector<int> blocks(n);
  for (int i = 0; i < n; i++) cin >> blocks[i];
  sort(all(blocks));

  for (int i = 0; i < N; i++) {
    dp[i] = -1;
    saver[i] = -1;
  }

  // opt
  int* curr = dp;
  int* nxt = saver;

  dp[0] = 0;
  saver[0] = 0;

  int cnt = 0;

  for (int h : blocks) {
    for (int d = 0; d <= cnt; d++) {
      nxt[d] = curr[d];
    }

    int limit = cnt + h;

    for (int d = cnt + 1; d <= cnt; d++) {
      nxt[d] = -1;
    }

    int l1 = min(cnt, h - 1);
    for (int d = 0; d <= l1; d++) {
      int val = curr[d];
      if (val == -1) continue;

      int v1 = val + h;
      if (v1 > nxt[d + h]) nxt[d + h] = v1;

      int v2 = val - d + h;
      int tmp = h - d;
      if (v2 > nxt[tmp]) nxt[tmp] = v2;
    }

    for (int d = h; d <= cnt; d++) {
      int val = curr[d];
      if (val == -1) continue;
      int v1 = val + h;
      if (v1 > nxt[d + h]) nxt[d + h] = v1;
      if (val > nxt[d - h]) nxt[d - h] = val;
    }
    cnt = min(limit, N - 1);
    swap(curr, nxt);
  }

  if (curr[0] > 0) {
    cout << "TAK\n" << curr[0] << "\n";
  } else {
    cout << "NIE\n";

    for (int d = 1; d <= cnt; d++) {
      if (curr[d] != -1 && (curr[d] - d > 0)) {
        cout << d << "\n";
        return;
      }
    }
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
