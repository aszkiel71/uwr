#include <algorithm>
#include <cassert>
#include <iostream>
#include <string>
#include <vector>

using namespace std;

#pragma GCC optimize("O3,unroll-loops")

#define debug(x) cout << #x << " = " << (x) << "\n"
#define all(x) (x).begin(), (x).end()
#define pb push_back

typedef long long ll;
const int N = 2e5 + 12;
const ll inf = 1e18 + 7;

struct ST {
  vector<int> tree;
  int size;
  int N;

  ST(int n) {
    N = n;
    size = 1;
    while (size <= N) size *= 2;
    tree.assign(2 * size + 8, 0);
  }

  ST(int n, vector<int>& B) {
    // my implementation:
    // https://github.com/aszkiel71/CP_Algorithms/blob/main/helpful/segtree.cpp
    N = n;
    size = 1;
    while (size <= N) size *= 2;

    tree.assign(2 * size + 5, 0);
    for (int i = size, j = 0; i < size + N && j < N; i++, j++) {
      tree[i] = B[j];
    }

    for (int i = size - 1; i >= 0; i--) {
      tree[i] = max(tree[2 * i], tree[2 * i + 1]);
    }
  }

  int query(int l, int r) { return query(1, l, r, 1, size); }

  void update(int x, int k) { return update(1, 1, size, k, x); }

  void update(int node, int start, int end, int pos, int dx) {
    if (pos < start || pos > end) {
      return;
    }

    if (start == end) {
      tree[node] = max(dx, tree[node]);
      return;
    }

    int mid = (start + end) / 2;
    update(2 * node, start, mid, pos, dx);
    update(2 * node + 1, mid + 1, end, pos, dx);
    tree[node] = max(tree[2 * node], tree[2 * node + 1]);
  }

  int query(int node, int l, int r, int start, int end) {
    if (start > r || end < l) {
      return -133333;
    }

    if (l <= start && end <= r) {
      return tree[node];
    }

    const int mid = (start + end) / 2;
    int left_query = query(2 * node, l, r, start, mid);
    int right_query = query(2 * node + 1, l, r, mid + 1, end);
    return max(left_query, right_query);
  }
};

int hlp(const vector<int>& a, int x) {
  int l = 0, r = (int)a.size() - 1;
  while (l <= r) {
    int mid = (r - l) / 2 + l;
    if (a[mid] == x) return mid + 1;
    if (a[mid] < x)
      l = mid + 1;
    else
      r = mid - 1;
  }
  return -1;
}

void solve() {
  // uprzedzajac pytania - wiem, ze overkill :)

  int n, res = 1;
  cin >> n;
  vector<int> a(n), srt(n), pref(n, 1), suff(n, 1);
  for (int i = 0; i < n; i++) {
    cin >> a[i];
    srt[i] = a[i];
  }

  if (n <= 1) {
    cout << n << "\n";
    return;
  }

  sort(all(srt));
  vector<int> values;
  values.pb(srt[0]);
  for (int i = 1; i < n; i++) {
    if (srt[i] != srt[i - 1]) values.pb(srt[i]);
  }

  for (int i = 1; i < n; i++) {
    pref[i] = 1 + pref[i - 1] * (a[i] > a[i - 1]);
    res = max(res, pref[i]);
  }

  for (int i = n - 2; i >= 0; i--) {
    suff[i] = 1 + (1 - (a[i] >= a[i + 1])) * suff[i + 1];
  }

  int m = (int)values.size();
  // vector<int> empty(m, 0);
  ST st(m);

  for (int i = 0; i < n; i++) {
    int id = hlp(values, a[i]);

    // najdluzszy lewy podciag ktory konczy sie wartoscia < a[i]
    if (id > 1) {
      int best = st.query(1, id - 1);
      res = max(res, best + suff[i]);
    }
    st.update(pref[i], id);
  }

  cout << res << "\n";
}

signed main() {
  ios_base::sync_with_stdio(false);
  cin.tie(0);

  int t = 1;
  cin >> t;
  while (t--) {
    solve();
  }
}
