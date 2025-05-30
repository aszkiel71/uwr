#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdint>
#include <queue>
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
#define LEFT cout << "LEFT\n"
#define RIGHT cout << "RIGHT\n"
#define TOUCH cout << "TOUCH\n"


ll det(ll x1, ll y1, ll x2, ll y2){
  return x1*y2-y1*x2;
}

fun feedback(ll sign_of_det){
    if (sign_of_det == 0)    TOUCH;
    else if (sign_of_det < 0) RIGHT;
    else if (sign_of_det > 0) LEFT;
}

signed main() {
    std::ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    int T; cin >> T;
    while (T--) {
        ll x1, y1, x2, y2, x3, y3;
        cin >> x1 >> y1 >> x2 >> y2 >> x3 >> y3;
        ll wx1 = x2 - x1, wy1 = y2 - y1;
        ll wx2 = x3 - x1, wy2 = y3 - y1;
        feedback(det(wx1, wy1, wx2, wy2));
    }


    return 0;
}
