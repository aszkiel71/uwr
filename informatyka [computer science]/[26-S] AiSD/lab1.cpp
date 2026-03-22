#include <algorithm>
#include <cassert>
#include <iostream>
#include <queue>
#include <string>
#include <vector>
// #define int long long

using namespace std;

#pragma GCC optimize("O3,unroll-loops")

#define debug(x) cout << #x << " = " << (x) << "\n"
#define all(x) (x).begin(), (x).end()
#define pb push_back

typedef long long ll;
const int N = 2e5 + 12;
const ll inf = 1e18 + 7;

const int NNN = 2137;
char grid[NNN][NNN];
int n, m;

/*vector<int> leaders;
//vector<int> sz;

void make_set(int x){
    leaders[x] = x;
    //sz[x] = 1;
}

int find_set(int x){
    if(x == leaders[x]) return x;
    return leaders[x] = find_set(leaders[x]);
}

void union_set(int u, int v){
    u = find_set(u); v = find_set(v);
    if(u == v) return;
    //if(sz[u] < sz[v]) swap(u, v);
    //sz[u] += sz[v];
    leaders[v] = leaders[u];
}*/

// vector<pair<int, int>> dir = {{1, 0}, {-1, 0}, {0, 1}, {0, -1}};

void bfs(int xs, int ys) {
  queue<int> q;
  q.push(xs * m + ys);
  grid[xs][ys] += 42;

  while (!q.empty()) {
    int curr = q.front();
    q.pop();
    int x = curr / m, y = curr % m;
    char c = grid[x][y] - 42;

    if (x + 1 < n) {
      char nc = grid[x + 1][y];
      if (nc >= 'B' && nc <= 'F') {
        if ((c == 'B' || c == 'E' || c == 'F') &&
            (nc == 'C' || nc == 'D' || nc == 'F')) {
          grid[x + 1][y] += 42;
          q.push((x + 1) * m + y);
        }
      }
    }

    if (x - 1 >= 0) {
      char nc = grid[x - 1][y];
      if (nc >= 'B' && nc <= 'F') {
        if ((c == 'C' || c == 'D' || c == 'F') &&
            (nc == 'B' || nc == 'E' || nc == 'F')) {
          grid[x - 1][y] += 42;
          q.push((x - 1) * m + y);
        }
      }
    }

    if (y + 1 < m) {
      char nc = grid[x][y + 1];
      if (nc >= 'B' && nc <= 'F') {
        if ((c == 'D' || c == 'E' || c == 'F') &&
            (nc == 'B' || nc == 'C' || nc == 'F')) {
          grid[x][y + 1] += 42;
          q.push(x * m + (y + 1));
        }
      }
    }

    if (y - 1 >= 0) {
      char nc = grid[x][y - 1];
      if (nc >= 'B' && nc <= 'F') {
        if ((c == 'B' || c == 'C' || c == 'F') &&
            (nc == 'D' || nc == 'E' || nc == 'F')) {
          grid[x][y - 1] += 42;
          q.push(x * m + (y - 1));
        }
      }
    }
  }
}

void solve() {
  scanf("%d%d\n", &n, &m);

  for (int i = 0; i < n; i++) {
    fgets(grid[i], NNN, stdin);
  }

  int cnt = 0;

  for (int i = 0; i < n; i++) {
    for (int j = 0; j < m; j++) {
      if (grid[i][j] >= 'B' && grid[i][j] <= 'F') {
        cnt++;
        bfs(i, j);
      }
    }
  }
  printf("%d\n", cnt);
}

signed main() {
  // ios_base::sync_with_stdio(false);
  // cin.tie(0);

  int t = 1;
  // cin >> t;
  while (t--) {
    solve();
  }
}
