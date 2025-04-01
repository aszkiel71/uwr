#include <iostream>
#include <algorithm>
#include <climits>
using namespace std;
#define ll long long
#define llm LONG_LONG_MIN
struct czworka {
    ll sum, prefix, suffix, max_sum;
};


ll max(ll a1, ll a2){
    return (a1>a2) ? a1 : a2;
}

int main() {
    ios_base::sync_with_stdio(false);   cin.tie(nullptr);
    int N, Q;cin >> N >> Q; int S = 1;  while (S < N) S *= 2;S -= 1;    czworka ST[4 * N + 4] = {0, llm/2, llm/2, llm/2};
    for (int i = S; i < S + N; i++) {int val;cin>>val;ST[i] = {val, val, val, val};}
    for (int i = S + N; i < 2 * S + 1; i++)     ST[i] = {0, llm/2, llm/2, llm/2};

    for (int i = S - 1; i >= 0; i--) {
        int left = 2 * i + 1;
        int secleft = 2 * i + 2;
        ST[i].sum = ST[left].sum + ST[secleft].sum;
        ST[i].prefix = max(ST[left].prefix, ST[left].sum + ST[secleft].prefix);
        ST[i].suffix = max(ST[secleft].suffix, ST[secleft].sum + ST[left].suffix);
        ST[i].max_sum = max({ST[left].max_sum, ST[secleft].max_sum,
                            ST[left].suffix + ST[secleft].prefix});
    }

    while (Q--) {
        int k, x;   cin >> k >> x;  k--;    int pos=k+S;    ST[pos] = {x, x, x, x}; pos = (pos-1)/2;
        while (pos >= 0) {
            int secright = 2*pos + 1;
            int right = 2*pos + 2;
            ST[pos].sum = ST[secright].sum + ST[right].sum;
            ST[pos].prefix = max(ST[secright].prefix, ST[secright].sum + ST[right].prefix);
            ST[pos].suffix = max(ST[right].suffix, ST[right].sum + ST[secright].suffix);
            ST[pos].max_sum = max({ST[secright].max_sum, ST[right].max_sum,
                                 ST[secright].suffix + ST[right].prefix});
            if (pos == 0) break;    pos = (pos - 1)/2;
        }
        cout << max(0, ST[0].max_sum) << "\n";
    }
    return 0;
}