#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdint>
#include <queue>
#include <iomanip>
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

double det(ll x1, ll y1, ll x2, ll y2){
    return x1*y2 - x2*y1;
}

signed main() {
    std::ios_base::sync_with_stdio(false); cin.tie(nullptr); cout.tie(nullptr);
    int N;cin >> N; long double res = 0;
    if (N < 3) {
        cout << std::fixed << std::setprecision(1) << 0.0; return 0;
    }

    ll x1, y1, xtmp, ytmp;    cin >> x1 >> y1;  cin >> xtmp >> ytmp; N --; --N;
    long double area = det(x1, y1, xtmp, ytmp);

    while (N--) {
        ll x, y; cin >> x >> y;
        area += det(xtmp, ytmp, x, y);
        xtmp = x;
        ytmp = y;
    }

    area += det(xtmp, ytmp, x1, y1);
    res = std::abs(area) / 2.0;

    cout << std::fixed << std::setprecision(1) << res;
    return 0;
}
