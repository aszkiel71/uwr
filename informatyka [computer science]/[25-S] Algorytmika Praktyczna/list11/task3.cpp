#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdint>
#include <iomanip>
#include <queue>
#include <cmath>
#pragma GCC optimize("Ofast")

typedef long long ll;
typedef int32_t i32;
typedef int64_t i64;
typedef uint32_t u32;
typedef uint64_t u64;

using std::cin;
using std::cout;
using std::vector;
using std::priority_queue;
#define fun void
#define LEFT cout << "LEFT\n";
#define RIGHT cout << "RIGHT\n";
#define TOUCH cout << "TOUCH\n";

long double det (ll x1, ll y1, ll x2, ll y2){
    return x1 * y2 - x2 * y1;
}

long double norm (ll x, ll y){
  return sqrt(x * x + y * y);
}

int main() {
    std::ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    cout << std::fixed << std::setprecision(9);

    int Q; cin >> Q;
    while(Q--){
      ll xp1, yp1, xp2, yp2, xq, yq;
      cin >> xp1 >> yp1 >> xp2 >> yp2 >> xq >> yq;
      ll wx1 = xq - xp1;
      ll wy1 = yq - yp1;
      ll wx2 = xp2 - xp1;
      ll wy2 = yp2 - yp1;
      long double res =  det (wx1, wy1, wx2, wy2) / norm (wx2, wy2) ;
        cout << std::abs(res) << '\n';
    }

    return 0;
}
