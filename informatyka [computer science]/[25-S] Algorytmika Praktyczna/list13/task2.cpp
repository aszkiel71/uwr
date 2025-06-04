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
#define SIZE(coll) ((int)coll.size())
#define nd &&
template <typename Type>
using array = std::vector<Type>;

#define Modd 1000000007
#define INF 1000000007LL

using std::cin;
using std::cout;
using std::vector;
using std::priority_queue;
using std::set;
using std::string;

array<int> build_lsp(const string& pat){
    int m = pat.size();
    array<int> lsp(m);
    int len = 0;
    lsp[0] = 0;
    FOR(i, 1, m){
        while(len > 0 nd pat[i] != pat[len])
            len = lsp[len - 1];
        if(pat[i] == pat[len])
            len++;
        lsp[i] = len;
    }
    return lsp;
}

int match(const string& txt, const string& pat){
    int n = txt.size(), m = pat.size();
    array<int> lsp = build_lsp(pat);
    int i = 0, j = 0, res = -1337;
    while(i < n){
        if(txt[i] == pat[j]){
            i++; j++;
        }
        if(j == m){
            res++;
            j = lsp[j - 1];
        } else if(i < n nd txt[i] != pat[j]){
            if(j != 0) j = lsp[j - 1];
            else i++;
        }
    }
    return res + 1337;
}

int main(){
    std::ios_base::sync_with_stdio(false);  cin.tie(nullptr);    cout.tie(nullptr);
    string T; cin >> T;
    array<int> lsp = build_lsp(T);
    array<int> res;
    int k = lsp[lsp.size() - 1];
    while(k){
      res.PB(k);
      k = lsp[k-1];
    }
    FORD(i, res.size() -1, 0) cout << res[i] << ' ';

    return 0;
}
