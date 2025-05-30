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
typedef double long dl;

#include <set>

using std::cin;
using std::cout;
using std::vector;
using std::priority_queue;
using std::set;
#define fun void
#define LEFT cout << "LEFT\n";
#define RIGHT cout << "RIGHT\n";
#define TOUCH cout << "TOUCH\n";


signed main() {
    std::ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    set<dl> angles;
    ll x; cin >> x;
    ll N; cin >> N;
    ll res = 0;
    while (N--) {
      ll x1, y1; cin >> x1 >> y1; x1 = x1 - x;
        dl ratio = static_cast<dl>(y1) / x1;
        if (angles.count(ratio)) {continue;}
        angles.insert(ratio);
        res++;
    }
    cout << res << '\n';
    return 0;
}
