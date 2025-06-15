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

int main() {
    std::ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);
    std::string S; cin >> S;

    int n = S.size();
    std::string T = "#";
    forr(i, n) {
        T += S[i]; T += "#";
    }

    int m = T.size();    vector<int> P(m, 0);
    int c = 0, r = 0, mxlen = 0, cntr = 0;

    FOR(i, 1, m - 1) {
        int mirror = 2 * c - i;
        if (i < r) P[i] = std::min(r-i, P[mirror]);

        while (i + P[i] + 1 < m && i - P[i] - 1 >= 0 && T[i + P[i] + 1] == T[i-P[i] - 1]) {
            P[i]++;
        }

        if (i + P[i] > r) {
            c = i;
            r = i + P[i];
        }

        if (P[i] > mxlen) {
            mxlen = P[i];
            cntr = i;
        }
    }

    int strt = (cntr - mxlen) / 2;
    FOR(i, strt, strt + mxlen) cout << S[i];
    cout << '\n';

    return 0;
}
