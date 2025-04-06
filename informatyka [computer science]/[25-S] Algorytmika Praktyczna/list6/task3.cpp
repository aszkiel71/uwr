#include <iostream>
#include <climits>
#define ll long long

using namespace std;

ll max(ll a1, ll a2) {
    return (a1 > a2) ? a1 : a2;
}

ll query(ll ST[], int node, int l, int r, int x, int y) {
    if (x <= l && r <= y)
        return ST[node];
    if (y < l || x > r)
        return 0;

    int mid = (l + r) / 2;
    return query(ST, 2*node + 1, l, mid, x, y) +
           query(ST, 2*node + 2, mid + 1, r, x, y);
}

void update(ll ST[], int node, int l, int r, int pos, ll delta) {

    if (pos < l || pos > r)
        return;

    ST[node] += delta;

    if (l != r) {
        int mid = (l + r) / 2;
        update(ST, 2*node + 1, l, mid, pos, delta);
        update(ST, 2*node + 2, mid + 1, r, pos, delta);
    }
}


ll max_st(ll ST[], int node, int start, int end, int l, int r) {
    if (r < start || l > end) return LLONG_MIN;
    if (l <= start && end <= r) return ST[node];

    int mid = (start + end) / 2;
    int left_child = 2 * node + 1;
    int right_child = 2 * node + 2;
    return max(max_st(ST, left_child, start, mid, l, r), max_st(ST, right_child, mid + 1, end, l, r));
}

int main() {
    ios_base::sync_with_stdio(false);
    cin.tie(nullptr);
    cout.tie(nullptr);

    int N, Q; cin >> N >> Q;    int S = 1; while (S < N) S *= 2; S--;

    ll Arr[N];
    for (int i = 0; i < N; ++i) {
        cin >> Arr[i];
    }

    ll pref[N];
    pref[0] = Arr[0];
    for (int i = 1; i < N; ++i) {
        pref[i] = pref[i - 1] + Arr[i];
    }

    ll ST_pref[4*N + 4] = {INT_MIN};
    for (int i = S; i < S + N; ++i) {ST_pref[i] = pref[i];}
    for (int i = S; i >= 0; i--) {ST_pref[i] = max(ST_pref[2*i + 1], ST_pref[2*i + 2]);}

    ll ST_changes[4*N + 4] = {0};

    while (Q--){
        int q; cin >> q;
        if (q == 1){
            int k; cin >> k; ll v; cin >> v; k--;   ll delta = v - Arr[k];
            update(ST_changes, 0, 0, k, k, delta);
        }
        else if (q == 2){
            int x, y; cin >> x >> y; x--; y--;  ll delta = query(ST_changes, 0, 0, N-1, x, y);
            ll val = max_st(ST_pref, 0, 0, N-1, x, y); ll prev_pref = 0;
            if (x > 0){ll prev_pref = pref[x-1] + ST_changes[S+x-1];}
            cout << val + delta - prev_pref << "\n";
        }
    }

    return 0;
}