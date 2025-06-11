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
    std::string T = S + S;
    int f[2*n];
    std::fill(f, f + n*2, -1);
    int k = 0;

    FOR(j, 1, 2 * n) {
        int i = f[j - k - 1];
        while (i != -1 && T[j] != T[k + i + 1]) {
            if (T[j] < T[k+i + 1]) k = j - i - 1;
            i = f[i];
        }
        if (i == -1 && T[j] != T[k]) {
            if (T[j] < T[k]) k = j;
            f[j - k] = -1;
        } else f[j - k] = i + 1;
    }

    FOR(i, 0, n) cout << T[k + i];
    cout << '\n';

    return 0;
}