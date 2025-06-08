#include <iostream>
#include <vector>
#include <algorithm>
#include <cstdint>
#pragma GCC optimize("Ofast")

typedef long long ll;
typedef int32_t i32;
typedef int64_t i64;
typedef uint32_t u32;
typedef uint64_t u64;

using std::cin;
using std::cout;
using std::vector;
#define fun void
#define LEFT cout << "LEFT\n"
#define RIGHT cout << "RIGHT\n"
#define TOUCH cout << "TOUCH\n"

ll det(ll x1, ll y1, ll x2, ll y2){
  return x1*y2 - y1*x2;
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

    int N;
    cin >> N;
    vector<std::pair<ll, ll>> pts(N);
    for (int i = 0; i < N; ++i) cin >> pts[i].first >> pts[i].second;

    std::sort(pts.begin(), pts.end());

    vector<std::pair<ll, ll>> tb;
    for (int i = 0; i < N; ++i) {
        while (tb.size() >= 2) {
            ll x1 = tb[tb.size()-2].first;  ll y1 = tb[tb.size()-2].second;
            ll x2 = tb[tb.size()-1].first;  ll y2 = tb[tb.size()-1].second;
            ll x3 = pts[i].first;           ll y3 = pts[i].second;
            if (det(x2 - x1, y2 - y1, x3 - x1, y3 - y1) < 0) tb.pop_back();
            else break;
        }
        tb.push_back(pts[i]);
    }
    int lw = tb.size();
    for (int i = N - 2; i >= 0; --i) {
        while ((int)tb.size() > lw) {
            ll x1 = tb[tb.size()-2].first;  ll y1 = tb[tb.size()-2].second;
            ll x2 = tb[tb.size()-1].first;  ll y2 = tb[tb.size()-1].second;
            ll x3 = pts[i].first;           ll y3 = pts[i].second;
            if (det(x2 - x1, y2 - y1, x3 - x1, y3 - y1) < 0) tb.pop_back();
            else break;
        }
        tb.push_back(pts[i]);
    }
    tb.pop_back();

    std::sort(tb.begin(), tb.end());
    cout << tb.size() << '\n';
    for (auto p : tb) cout << p.first << ' ' << p.second << '\n';

    return 0;
}
