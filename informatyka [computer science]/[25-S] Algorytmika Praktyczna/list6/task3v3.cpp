#include <iostream>
#define ll long long
using namespace std;

struct ourpair { ll pref, sum; };

ll max(ll a, ll b) { return a > b ? a : b; }

ourpair query(ourpair ST[], int node, int l, int r, int x, int y) {
    if (y < l || x > r) return {0, 0};
    if (x <= l && r <= y) return {ST[node].pref, ST[node].sum};
    int mid = (l + r) / 2;
    ourpair left = query(ST, 2*node+1, l, mid, x, y);
    ourpair right = query(ST, 2*node+2, mid+1, r, x, y);
    if (left.pref == 0 && left.sum == 0) return right;
    if (right.pref == 0 && right.sum == 0) return left;
    return {max(left.pref, left.sum + right.pref), left.sum + right.sum};
}

void update(ourpair ST[], int S, int pos, ll value) {
    int node = S + pos;
    ST[node].pref = ST[node].sum = value;
    while (node > 0) {
        node = (node - 1) / 2;
        int left = 2*node + 1, right = 2*node + 2;
        ST[node].sum = ST[left].sum + ST[right].sum;
        ST[node].pref = max(ST[left].pref, ST[left].sum + ST[right].pref);
    }
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr); cout.tie(nullptr);
    int N, Q; cin >> N >> Q;
    int S = 1; while (S < N) S *= 2; S--;
    ourpair* ST = new ourpair[4*N + 4]();
    for (int i = S; i < S + N; ++i) {
        cin >> ST[i].pref;
        ST[i].sum = ST[i].pref;
    }
    for (int i = S-1; i >= 0; --i) {
        ST[i].sum = ST[2*i+1].sum + ST[2*i+2].sum;
        ST[i].pref = max(ST[2*i+1].pref, ST[2*i+1].sum + ST[2*i+2].pref);
    }
    while (Q--) {
        int q; cin >> q;
        if (q == 1) {
            int k; ll v; cin >> k >> v;
            update(ST, S, k-1, v);
        } else {
            int x, y; cin >> x >> y; x--; y--;
            ourpair res = query(ST, 0, 0, N-1, x, y);
            cout << max(res.pref, 0) << '\n';
        }
    }

    return 0;
}