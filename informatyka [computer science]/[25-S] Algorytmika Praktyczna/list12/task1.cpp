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

#define forr(i, n) for(int i = 0; i < n; i++)
#define FOREACH(iter, coll) for(auto iter = coll.begin(); iter != coll.end(); iter++)
#define FOR(i, a, b) for(int i = a; i < b; i++)
#define FORD(i, a, b) for(int i = a; i >= b; i--)
#define MP make_pair
#define PB push_back
#define ff first
#define ss second
#define SIZE(coll) ((int)coll.size)

#define M 1000000007
#define INF 1000000007LL

using std::cin;
using std::cout;
using std::vector;
using std::priority_queue;
using std::set;
using std::string;

const int base = 31;

ll hash (const string& T){
    ll hsh = 0; ll pw = 1;
    for (char c : T){
        hsh = (hsh + (c * pw) % M) % M;
        pw = (pw * base) % M;
    }
    return hsh;
}

signed main(){
    std::ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    string T, P;
    cin >> T >> P;
    int n = T.size(), m = P.size();
    if (n < m) {cout << 0; return 0; }
    int ans = 0;

    ll pattern = 0, txt = 0; ll pw = 1;

    forr(i, m - 1) pw = (pw * base) % M;

    forr(i, m) {
        pattern = (pattern * base + P[i]) % M;
        txt = (txt * base + T[i]) % M;
    }


    if (txt == pattern && T.substr(0, m) == P) ans++;

    FOR(i, 1, n - m + 1) {
        //removing first char from the left then we add first from the right
        txt = (txt - (T[i - 1] * pw) % M + M) % M;
        txt = (txt * base + T[i + m - 1]) % M;
        if (txt == pattern) ans++;
    }


    cout << ans;
    return 0;
}
